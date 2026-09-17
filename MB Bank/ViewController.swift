import UIKit
import UserNotifications
import AudioToolbox

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        sv.keyboardDismissMode = .onDrag
        return sv
    }()

    private let contentView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    // Header Branding
    private let headerCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.0, green: 0.2, blue: 0.63, alpha: 1.0) // #0033A0 MB Blue
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor(red: 0.0, green: 0.1, blue: 0.4, alpha: 0.25).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "MB BANK"
        label.font = UIFont.systemFont(ofSize: 22, weight: .black)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let headerSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mô phỏng thông báo biến động số dư"
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.85)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Live Notification Preview Card
    private let previewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.08
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor(white: 0.92, alpha: 1.0).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let previewHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "XEM TRƯỚC THÔNG BÁO (LIVE PREVIEW)"
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        label.textColor = UIColor(red: 0.0, green: 0.2, blue: 0.63, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let previewAppIcon: UIImageView = {
        let iv = UIImageView()
        if #available(iOS 13.0, *) {
            iv.image = UIImage(systemName: "bell.badge.fill")
        }
        iv.tintColor = UIColor(red: 0.0, green: 0.2, blue: 0.63, alpha: 1.0)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let previewAppName: UILabel = {
        let label = UILabel()
        label.text = "MB BANK • vừa xong"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let previewTitle: UILabel = {
        let label = UILabel()
        label.text = "Thông báo biến động số dư"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let previewBody: UILabel = {
        let label = UILabel()
        label.text = "TK 10xxx789|GD: +1,000,000VND 17/09/24 10:00 |SD: 5,000,000VND|ND: Luong thang"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(white: 0.2, alpha: 1.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Segmented Transaction Type
    private let transactionTypeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["+ Nhận tiền", "- Trừ tiền"])
        sc.selectedSegmentIndex = 0
        sc.selectedSegmentTintColor = UIColor(red: 0.06, green: 0.72, blue: 0.51, alpha: 1.0) // Mint green
        sc.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 14, weight: .bold)], for: .selected)
        sc.setTitleTextAttributes([.foregroundColor: UIColor.darkGray, .font: UIFont.systemFont(ofSize: 14, weight: .medium)], for: .normal)
        sc.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()

    // App Icon Picker (Đổi Icon ngoài màn hình chính)
    private let iconLabel: UILabel = {
        let label = UILabel()
        label.text = "BIỂU TƯỢNG APP NGOÀI MÀN HÌNH CHÍNH"
        label.font = UIFont.systemFont(ofSize: 11.5, weight: .bold)
        label.textColor = UIColor(red: 0.0, green: 0.2, blue: 0.63, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let iconSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["MB Xanh", "MB Gold VIP", "MB Dark"])
        sc.selectedSegmentIndex = 0
        sc.selectedSegmentTintColor = UIColor(red: 0.0, green: 0.2, blue: 0.63, alpha: 1.0)
        sc.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 13, weight: .bold)], for: .selected)
        sc.setTitleTextAttributes([.foregroundColor: UIColor.darkGray, .font: UIFont.systemFont(ofSize: 13, weight: .medium)], for: .normal)
        sc.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()

    // Input Fields (Không còn icon, sạch sẽ chuẩn minimalist banking)
    private let accountTextField = ViewController.createCleanTextField(placeholder: "Ví dụ: 0386868686")
    private let amountTextField = ViewController.createCleanTextField(placeholder: "Ví dụ: 1,000,000")
    private let timeTextField = ViewController.createCleanTextField(placeholder: "Chọn ngày giờ hoặc bấm Hiện tại")
    private let balanceTextField = ViewController.createCleanTextField(placeholder: "Ví dụ: 5,000,000")
    private let descriptionTextField = ViewController.createCleanTextField(placeholder: "Ví dụ: Chuyen tien")

    // Utility Buttons (Giờ hiện tại & Xóa nhanh)
    private let nowTimeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Lấy giờ hiện tại", for: .normal)
        btn.setTitleColor(UIColor(red: 0.0, green: 0.2, blue: 0.63, alpha: 1.0), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12.5, weight: .bold)
        btn.backgroundColor = UIColor(red: 0.0, green: 0.2, blue: 0.63, alpha: 0.08)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let clearAllButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Xóa dữ liệu", for: .normal)
        btn.setTitleColor(.systemRed, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12.5, weight: .bold)
        btn.backgroundColor = UIColor.systemRed.withAlphaComponent(0.08)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // Date Picker
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.locale = Locale(identifier: "vi_VN")
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    // Action Button
    private let scheduleNotificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tạo Thông Báo Biến Động", for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.0, green: 0.2, blue: 0.63, alpha: 1.0)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.layer.shadowColor = UIColor(red: 0.0, green: 0.2, blue: 0.63, alpha: 0.4).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 1.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1.0)

        setupUI()
        setupActions()
        setupDatePicker()
        checkNotificationPermission()
        UNUserNotificationCenter.current().delegate = self

        setNowTime()
        updateLivePreview()
    }

    // MARK: - Helper UI Factory
    private static func createCleanTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(white: 0.88, alpha: 1.0).cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false

        // Padding lề trái & lề phải sạch sẽ, không có icon
        let paddingLeft = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 48))
        textField.leftView = paddingLeft
        textField.leftViewMode = .always

        let paddingRight = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 48))
        textField.rightView = paddingRight
        textField.rightViewMode = .always

        return textField
    }

    private func createFieldGroup(title: String, textField: UITextField) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = UIColor(white: 0.35, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(label)
        container.addSubview(textField)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6),
            textField.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 48)
        ])

        return container
    }

    // MARK: - Setup Layout
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Add Header
        contentView.addSubview(headerCardView)
        headerCardView.addSubview(headerTitleLabel)
        headerCardView.addSubview(headerSubtitleLabel)

        // Add Live Preview
        contentView.addSubview(previewContainer)
        previewContainer.addSubview(previewHeaderLabel)
        previewContainer.addSubview(previewAppIcon)
        previewContainer.addSubview(previewAppName)
        previewContainer.addSubview(previewTitle)
        previewContainer.addSubview(previewBody)

        // Add Segmented
        contentView.addSubview(transactionTypeSegmentedControl)

        // Utility Buttons Row
        let utilityRow = UIStackView(arrangedSubviews: [nowTimeButton, clearAllButton])
        utilityRow.axis = .horizontal
        utilityRow.spacing = 10
        utilityRow.distribution = .fillEqually
        utilityRow.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(utilityRow)

        // Create Groups
        let accountGroup = createFieldGroup(title: "SỐ TÀI KHOẢN MB", textField: accountTextField)
        let amountGroup = createFieldGroup(title: "SỐ TIỀN GIAO DỊCH (VND)", textField: amountTextField)
        let timeGroup = createFieldGroup(title: "THỜI GIAN GIAO DỊCH", textField: timeTextField)
        let balanceGroup = createFieldGroup(title: "SỐ DƯ TÀI KHOẢN (VND)", textField: balanceTextField)
        let descGroup = createFieldGroup(title: "NỘI DUNG BIẾN ĐỘNG", textField: descriptionTextField)

        let stackView = UIStackView(arrangedSubviews: [accountGroup, amountGroup, timeGroup, balanceGroup, descGroup])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        contentView.addSubview(scheduleNotificationButton)

        contentView.addSubview(iconLabel)
        contentView.addSubview(iconSegmentedControl)

        // Constraints
        NSLayoutConstraint.activate([
            // Header
            headerCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            headerCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            headerTitleLabel.topAnchor.constraint(equalTo: headerCardView.topAnchor, constant: 16),
            headerTitleLabel.leadingAnchor.constraint(equalTo: headerCardView.leadingAnchor, constant: 18),
            headerTitleLabel.trailingAnchor.constraint(equalTo: headerCardView.trailingAnchor, constant: -18),

            headerSubtitleLabel.topAnchor.constraint(equalTo: headerTitleLabel.bottomAnchor, constant: 4),
            headerSubtitleLabel.leadingAnchor.constraint(equalTo: headerTitleLabel.leadingAnchor),
            headerSubtitleLabel.trailingAnchor.constraint(equalTo: headerTitleLabel.trailingAnchor),
            headerSubtitleLabel.bottomAnchor.constraint(equalTo: headerCardView.bottomAnchor, constant: -16),

            // Preview Container
            previewContainer.topAnchor.constraint(equalTo: headerCardView.bottomAnchor, constant: 16),
            previewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            previewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            previewHeaderLabel.topAnchor.constraint(equalTo: previewContainer.topAnchor, constant: 12),
            previewHeaderLabel.leadingAnchor.constraint(equalTo: previewContainer.leadingAnchor, constant: 14),

            previewAppIcon.topAnchor.constraint(equalTo: previewHeaderLabel.bottomAnchor, constant: 10),
            previewAppIcon.leadingAnchor.constraint(equalTo: previewContainer.leadingAnchor, constant: 14),
            previewAppIcon.widthAnchor.constraint(equalToConstant: 20),
            previewAppIcon.heightAnchor.constraint(equalToConstant: 20),

            previewAppName.centerYAnchor.constraint(equalTo: previewAppIcon.centerYAnchor),
            previewAppName.leadingAnchor.constraint(equalTo: previewAppIcon.trailingAnchor, constant: 8),

            previewTitle.topAnchor.constraint(equalTo: previewAppIcon.bottomAnchor, constant: 8),
            previewTitle.leadingAnchor.constraint(equalTo: previewContainer.leadingAnchor, constant: 14),
            previewTitle.trailingAnchor.constraint(equalTo: previewContainer.trailingAnchor, constant: -14),

            previewBody.topAnchor.constraint(equalTo: previewTitle.bottomAnchor, constant: 6),
            previewBody.leadingAnchor.constraint(equalTo: previewContainer.leadingAnchor, constant: 14),
            previewBody.trailingAnchor.constraint(equalTo: previewContainer.trailingAnchor, constant: -14),
            previewBody.bottomAnchor.constraint(equalTo: previewContainer.bottomAnchor, constant: -14),

            // Segmented Control
            transactionTypeSegmentedControl.topAnchor.constraint(equalTo: previewContainer.bottomAnchor, constant: 18),
            transactionTypeSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            transactionTypeSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            transactionTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 44),

            // Utility Row
            utilityRow.topAnchor.constraint(equalTo: transactionTypeSegmentedControl.bottomAnchor, constant: 12),
            utilityRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            utilityRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            utilityRow.heightAnchor.constraint(equalToConstant: 34),

            // Form Stack
            stackView.topAnchor.constraint(equalTo: utilityRow.bottomAnchor, constant: 14),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Schedule Button
            scheduleNotificationButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24),
            scheduleNotificationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            scheduleNotificationButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            scheduleNotificationButton.heightAnchor.constraint(equalToConstant: 54),

            // Icon Label & Segmented
            iconLabel.topAnchor.constraint(equalTo: scheduleNotificationButton.bottomAnchor, constant: 28),
            iconLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            iconSegmentedControl.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 8),
            iconSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            iconSegmentedControl.heightAnchor.constraint(equalToConstant: 42),
            iconSegmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])

        // Keyboards
        accountTextField.keyboardType = .numberPad
        amountTextField.keyboardType = .numberPad
        balanceTextField.keyboardType = .numberPad

        // Tap to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: - Setup Actions & Delegates
    private func setupActions() {
        let textFields = [accountTextField, amountTextField, timeTextField, balanceTextField, descriptionTextField]
        for tf in textFields {
            tf.delegate = self
            tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }

        transactionTypeSegmentedControl.addTarget(self, action: #selector(transactionTypeChanged), for: .valueChanged)
        iconSegmentedControl.addTarget(self, action: #selector(iconSegmentedChanged), for: .valueChanged)

        nowTimeButton.addTarget(self, action: #selector(setNowTime), for: .touchUpInside)
        clearAllButton.addTarget(self, action: #selector(clearAllFields), for: .touchUpInside)

        scheduleNotificationButton.addTarget(self, action: #selector(scheduleNotification), for: .touchUpInside)
        scheduleNotificationButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        scheduleNotificationButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    @objc private func iconSegmentedChanged() {
        hapticFeedback.impactOccurred()
        let selectedIndex = iconSegmentedControl.selectedSegmentIndex
        let iconName: String?
        if selectedIndex == 1 {
            iconName = "IconGold"
        } else if selectedIndex == 2 {
            iconName = "IconDark"
        } else {
            iconName = nil // Về icon gốc MB Xanh
        }
        changeAppIcon(to: iconName)
    }

    private func changeAppIcon(to iconName: String?) {
        guard UIApplication.shared.supportsAlternateIcons else {
            showAlert(message: "Thiết bị không hỗ trợ đổi icon ứng dụng!")
            return
        }
        UIApplication.shared.setAlternateIconName(iconName) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showAlert(message: "Lỗi đổi icon: \(error.localizedDescription)")
                } else {
                    let name = (iconName == "IconGold") ? "MB Gold VIP" : (iconName == "IconDark" ? "MB Dark Platinum" : "MB Xanh Mặc Định")
                    self?.showAlert(message: "Đã đổi biểu tượng ngoài màn hình chính sang: \(name)")
                }
            }
        }
    }

    private func setupDatePicker() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Chọn", style: .done, target: self, action: #selector(datePickerDone))
        doneButton.tintColor = UIColor(red: 0.0, green: 0.2, blue: 0.63, alpha: 1.0)
        toolBar.setItems([flexibleSpace, doneButton], animated: false)

        timeTextField.inputView = datePicker
        timeTextField.inputAccessoryView = toolBar
    }

    @objc private func setNowTime() {
        hapticFeedback.impactOccurred()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy HH:mm"
        formatter.locale = Locale(identifier: "vi_VN")
        timeTextField.text = formatter.string(from: Date())
        datePicker.date = Date()
        updateLivePreview()
    }

    @objc private func clearAllFields() {
        hapticFeedback.impactOccurred()
        accountTextField.text = ""
        amountTextField.text = ""
        balanceTextField.text = ""
        descriptionTextField.text = ""
        setNowTime()
        updateLivePreview()
    }

    // MARK: - Dynamic Live Preview
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField == amountTextField || textField == balanceTextField {
            if let text = textField.text {
                let cleanNumber = text.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
                if let number = Double(cleanNumber) {
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    formatter.groupingSeparator = ","
                    textField.text = formatter.string(from: NSNumber(value: number))
                }
            }
        }
        updateLivePreview()
    }

    @objc private func transactionTypeChanged() {
        hapticFeedback.impactOccurred()
        if transactionTypeSegmentedControl.selectedSegmentIndex == 0 {
            transactionTypeSegmentedControl.selectedSegmentTintColor = UIColor(red: 0.06, green: 0.72, blue: 0.51, alpha: 1.0)
        } else {
            transactionTypeSegmentedControl.selectedSegmentTintColor = UIColor(red: 0.94, green: 0.27, blue: 0.27, alpha: 1.0)
        }
        updateLivePreview()
    }

    private func updateLivePreview() {
        let rawAccount = accountTextField.text?.isEmpty == false ? accountTextField.text! : "0386868686"
        let masked = maskAccountNumber(account: rawAccount)
        let rawAmount = amountTextField.text?.isEmpty == false ? amountTextField.text! : "1,000,000"
        let time = timeTextField.text?.isEmpty == false ? timeTextField.text! : "17/09/24 10:00"
        let rawBalance = balanceTextField.text?.isEmpty == false ? balanceTextField.text! : "5,000,000"
        let desc = descriptionTextField.text?.isEmpty == false ? descriptionTextField.text! : "Chuyen tien"

        let isAdd = transactionTypeSegmentedControl.selectedSegmentIndex == 0
        let sign = isAdd ? "+" : "-"

        previewBody.text = "TK \(masked)|GD: \(sign)\(rawAmount)VND \(time) |SD: \(rawBalance)VND|ND: \(desc)"
    }

    private func maskAccountNumber(account: String) -> String {
        if account.count >= 5 {
            let start = account.prefix(2)
            let end = account.suffix(3)
            return "\(start)xxx\(end)"
        }
        return account
    }

    // MARK: - Notification Logic
    @objc private func scheduleNotification() {
        hapticFeedback.impactOccurred()

        let account = accountTextField.text ?? ""
        let amount = amountTextField.text ?? ""
        let time = timeTextField.text ?? ""
        let balance = balanceTextField.text ?? ""
        let description = descriptionTextField.text ?? ""

        if account.isEmpty || amount.isEmpty || time.isEmpty || balance.isEmpty || description.isEmpty {
            showAlert(message: "Vui lòng nhập đầy đủ các thông tin giao dịch!")
            return
        }

        let maskedAccount = maskAccountNumber(account: account)
        let transactionType = transactionTypeSegmentedControl.selectedSegmentIndex
        let sign = (transactionType == 0) ? "+" : "-"

        let notificationTitle = "Thông báo biến động số dư"
        let notificationMessage = "TK \(maskedAccount)|GD: \(sign)\(amount)VND \(time) |SD: \(balance)VND|ND: \(description)"

        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.body = notificationMessage
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(datePicker.date.timeIntervalSinceNow, 1), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showAlert(message: "Lỗi lên lịch thông báo: \(error.localizedDescription)")
                } else {
                    UIDevice.vibrate()
                    let alert = UIAlertController(title: "Thành công 🎉", message: "Đã lên lịch thông báo biến động số dư!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Tuyệt vời", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    private func checkNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }

    // MARK: - Actions
    @objc private func datePickerDone() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy HH:mm"
        formatter.locale = Locale(identifier: "vi_VN")
        timeTextField.text = formatter.string(from: datePicker.date)
        timeTextField.resignFirstResponder()
        updateLivePreview()
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func buttonTouchDown(sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }
    }

    @objc private func buttonTouchUp(sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            sender.transform = .identity
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            textField.layer.borderColor = UIColor(red: 0.0, green: 0.2, blue: 0.63, alpha: 1.0).cgColor
            textField.layer.borderWidth = 1.5
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            textField.layer.borderColor = UIColor(white: 0.88, alpha: 1.0).cgColor
            textField.layer.borderWidth = 1.0
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge, .list])
    }
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
