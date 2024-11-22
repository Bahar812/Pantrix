import SwiftUI
import AVFoundation

struct AddPantry: View {
    @State private var selectionAdd: String = "Add Manually"
    @State private var nameIngredient: String = ""
    @State private var quantity: String = ""
    @State private var typeQuantity: String = "kg" // Default value
    @State private var typeIngredient: String = "Vegetable" // Default value
    @State private var dateExpired: Date = Date() // Menggunakan tipe `Date`
    @State private var image: UIImage? = nil
    @State private var isImagePickerPresented: Bool = false
    
    // Dropdown options
    let typeQuantities = ["kg", "unit", "liters"]
    let typeIngredients = ["Vegetable", "Protein", "Fruit", "Drink"]

    var body: some View {
        NavigationView {
            VStack {
                if selectionAdd == "Add Manually" {
                    manuallyAddView
                } else {
                    ScanItemView(onScanComplete: { name, quantity in
                        self.nameIngredient = name
                        self.quantity = quantity
                        self.selectionAdd = "Add Manually" // Switch back to manual entry after scan
                    })
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("", selection: $selectionAdd) {
                        Text("Add Manually").tag("Add Manually")
                        Text("Scan the Item").tag("Scan the Item")
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // Manually add ingredients
    var manuallyAddView: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                VStack(spacing: 6) {
                    Text("Add manually")
                        .font(.title)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Manually Insert Item")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                .padding(.vertical, 20)

                // Image Picker
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    ZStack {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 150)
                                .overlay(
                                    VStack {
                                        Image(systemName: "camera")
                                            .font(.largeTitle)
                                            .foregroundColor(.gray)
                                        Text("Choose Image")
                                            .foregroundColor(.gray)
                                    }
                                )
                        }
                    }
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(image: $image)
                }

                // Input Fields
                VStack(spacing: 20) {
                    TextField("Name Ingredient", text: $nameIngredient)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    HStack {
                        TextField("Quantity", text: $quantity)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity)

                        Picker("Type Quantity", selection: $typeQuantity) {
                            ForEach(typeQuantities, id: \.self) { type in
                                Text(type).tag(type)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.5))
                        )
                    }

                    Picker("Type Ingredient", selection: $typeIngredient) {
                        ForEach(typeIngredients, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray.opacity(0.5))
                    )

                    // Date Picker
                    DatePicker("Date Expired", selection: $dateExpired, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.5))
                        )
                }
                .padding(.horizontal)

                // Add Item Button
                Button(action: {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    let formattedDate = formatter.string(from: dateExpired)
                    print("Item Added: \(nameIngredient), \(quantity) \(typeQuantity), \(typeIngredient), \(formattedDate)")
                }) {
                    Text("Add Item")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

struct ScanItemView: View {
    @Environment(\.dismiss) var dismiss
    var onScanComplete: (String, String) -> Void

    var body: some View {
        CameraScanner { detectedText, barcode in
            let itemName = detectedText ?? "Unknown Item"
            let quantity = barcode ?? "1" // Default quantity
            onScanComplete(itemName, quantity)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct CameraScanner: UIViewControllerRepresentable {
    var onDetect: (String?, String?) -> Void

    func makeUIViewController(context: Context) -> ScannerViewController {
        let vc = ScannerViewController()
        vc.onDetect = onDetect
        return vc
    }

    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {}
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var onDetect: ((String?, String?) -> Void)?

    private let session = AVCaptureSession()
    private let metadataOutput = AVCaptureMetadataOutput()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice)
        if session.canAddInput(videoInput!) {
            session.addInput(videoInput!)
        }

        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        session.startRunning()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session.stopRunning()

        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            onDetect?(nil, metadataObject.stringValue)
        }
    }
}

#Preview {
    AddPantry()
}
