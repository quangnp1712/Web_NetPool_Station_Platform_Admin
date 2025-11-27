import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_netpool_station_platform_admin/core/theme/app_colors.dart';
import 'package:web_netpool_station_platform_admin/feature/6_Space_Management/6.1_Space_List/bloc/space_list_bloc.dart';
import 'package:web_netpool_station_platform_admin/feature/6_Space_Management/6.1_Space_List/model/space_list_model.dart';
import 'package:web_netpool_station_platform_admin/feature/Common/snackbar/snackbar.dart';

//! Space List - DS - Update Spcace !//

class SpaceListPage extends StatefulWidget {
  const SpaceListPage({super.key});

  @override
  State<SpaceListPage> createState() => _SpaceListPageState();
}

class _SpaceListPageState extends State<SpaceListPage> {
  final SpaceListBloc _bloc = SpaceListBloc();
  // --- DATA TĨNH CHO PICKER ---
  final List<String> _presetColors = [
    "#CB30E0",
    "#2EBD59",
    "#00C6FF",
    "#FF9800",
    "#F44336",
    "#E91E63",
    "#9C27B0",
    "#3F51B5",
    "#FFC107",
    "#009688",
    "#795548",
  ];

  final Map<String, dynamic> _presetIcons = {
    "BIDA": "assets/icons/billiard.png",
    "PC": Icons.computer_outlined,
    "PS5": Icons.gamepad_outlined,
    "SOCCER": Icons.sports_soccer_outlined,
    "TENNIS": Icons.sports_tennis,
    "GYM": Icons.fitness_center_outlined,
    "OTHER": Icons.category_outlined,
  };

  @override
  void initState() {
    super.initState();
    _bloc.add(SpaceListInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: BlocConsumer<SpaceListBloc, SpaceListState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state.status == SpaceStatus.success && state.message.isNotEmpty) {
            ShowSnackBar(state.message, true);
          }
          if (state.status == SpaceStatus.failure) {
            ShowSnackBar(state.message, false);
          }
          if (state.blocState == SpaceListBlocState.UpdateSpaceSucessState) {
            _bloc.add(SpaceListInitialEvent());
          }
        },
        builder: (context, state) {
          if (state.status == SpaceStatus.loading) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGlow));
          }

          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header & Create Button
                _buildHeader(context),
                const SizedBox(height: 32),

                // Grid View
                Expanded(
                  child: state.spaces.isEmpty
                      ? _buildEmptyState()
                      : _buildGridList(context, state.spaces),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Quản lý Loại hình",
                style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 28,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Danh sách các loại hình dịch vụ tại Station",
                style: TextStyle(
                    color: AppColors.textHint.withOpacity(0.8), fontSize: 14)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showSpaceDialog(context, null, ScreenMode.create),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("THÊM LOẠI HÌNH",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGlow,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildGridList(BuildContext context, List<SpaceModel> spaces) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 1200
            ? 4
            : (constraints.maxWidth > 800 ? 3 : 2);
        return GridView.builder(
          itemCount: spaces.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.3,
          ),
          itemBuilder: (context, index) =>
              _buildSpaceCard(context, spaces[index]),
        );
      },
    );
  }

  Widget _buildIcon(dynamic iconData, Color color, {double size = 24}) {
    if (iconData is String) {
      // Nếu là đường dẫn ảnh (Asset)
      return Image.asset(
        iconData,
        width: size,
        height: size,
        color: color, // Tô màu cho ảnh (nếu ảnh transparent)
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.broken_image, color: color, size: size),
      );
    } else if (iconData is IconData) {
      // Nếu là Icon Font
      return Icon(
        iconData,
        color: color,
        size: size,
      );
    }
    // Fallback
    return Icon(Icons.category, color: color, size: size);
  }

  // --- HELPER COLORS/ICONS ---
  dynamic _getIconDataFromCode(String? code) {
    return _presetIcons[code?.toUpperCase()] ?? Icons.category_outlined;
  }

  Color _getColorFromHex(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) return AppColors.primaryGlow;
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xff')));
    } catch (_) {
      return AppColors.primaryGlow;
    }
  }

  Widget _buildSpaceCard(BuildContext context, SpaceModel space) {
    final bool isActive = space.statusCode == 'ACTIVE';
    final Color themeColor = _getColorFromHex(space.color);

    // [SỬA] Lấy dynamic data thay vì ép kiểu IconData
    final dynamic iconData = _getIconDataFromCode(space.icon ?? space.typeCode);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.containerBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isActive ? themeColor.withOpacity(0.5) : Colors.white10,
            width: 1.5),
        boxShadow: [
          if (isActive)
            BoxShadow(
                color: themeColor.withOpacity(0.15),
                blurRadius: 15,
                spreadRadius: 0,
                offset: const Offset(0, 4))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showSpaceDialog(context, space, ScreenMode.view),
          hoverColor: themeColor.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isActive
                            ? themeColor.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // [SỬA] Sử dụng _buildIcon
                      child: _buildIcon(
                          iconData, isActive ? themeColor : Colors.grey,
                          size: 24),
                    ),
                    Switch(
                      value: isActive,
                      activeColor: themeColor,
                      onChanged: (val) {
                        _showStatusConfirm(context, space, val);
                      },
                    ),
                  ],
                ),
                const Spacer(),
                Text(space.typeName ?? "Unknown",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(space.description ?? "Chưa có mô tả",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5), fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                const Divider(color: Colors.white10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: isActive
                              ? Colors.green.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(isActive ? "Hoạt động" : "Ngừng hoạt động",
                          style: TextStyle(
                              color: isActive ? Colors.green : Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () =>
                              _showSpaceDialog(context, space, ScreenMode.edit),
                          child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.edit,
                                  size: 18, color: Colors.blue)),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () => _showDeleteConfirm(context, space),
                          child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.delete,
                                  size: 18, color: Colors.red)),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
        child: Text("Chưa có loại hình nào",
            style: TextStyle(color: AppColors.textHint, fontSize: 18)));
  }

  // --- CONFIRM DIALOGS ---
  void _showDeleteConfirm(BuildContext context, SpaceModel space) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.inputBackground,
        title:
            const Text("Xác nhận xóa", style: TextStyle(color: Colors.white)),
        content: Text("Bạn có chắc chắn xóa '${space.typeName}'?",
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Hủy", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () {
              _bloc.add(DeleteSpaceEvent(space.spaceId!));
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Xóa", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void _showStatusConfirm(
      BuildContext context, SpaceModel space, bool newValue) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.inputBackground,
        title: const Text("Xác nhận trạng thái",
            style: TextStyle(color: Colors.white)),
        content: Text(
            "Bạn muốn đổi trạng thái thành '${newValue ? "Hoạt động" : "Ngừng hoạt động"}'?",
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Hủy", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () {
              _bloc.add(ChangeSpaceStatusEvent(
                  space.spaceId!, newValue ? "ACTIVE" : "INACTIVE"));
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGlow),
            child:
                const Text("Xác nhận", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  // --- MAIN FORM DIALOG (VIEW / EDIT / CREATE) ---
  void _showSpaceDialog(
      BuildContext context, SpaceModel? space, ScreenMode mode) {
    final _formKeyDialog = GlobalKey<FormState>();

// Init Controllers
    final nameController = TextEditingController(text: space?.typeName ?? "");
    final codeController = TextEditingController(text: space?.typeCode ?? "");
    final descController =
        TextEditingController(text: space?.description ?? "");

// State local cho Dialog
    ScreenMode currentMode = mode;
    String selectedColor = space?.color ?? _presetColors[0];
    // [SỬA] Lấy icon code (String)
    String selectedIconCode =
        space?.icon ?? space?.typeCode ?? _presetIcons.keys.first;
    String status = space?.statusCode ?? "ACTIVE";
    final bool isActive = space?.statusCode == 'ACTIVE';
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            final bool isReadOnly = currentMode == ScreenMode.view;
            final bool isCreate = currentMode == ScreenMode.create;
            final bool isEdit = currentMode == ScreenMode.edit;
            final String title = isCreate
                ? "Thêm Loại hình"
                : (isReadOnly ? "Chi tiết Loại hình" : "Cập nhật Loại hình");

            return AlertDialog(
              backgroundColor: AppColors.containerBackground,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white)),
                  if (!isCreate)
                    InkWell(
                      onTap: () {
                        setState(() {
                          currentMode =
                              isReadOnly ? ScreenMode.edit : ScreenMode.view;
                          if (currentMode == ScreenMode.view) {
                            nameController.text = space?.typeName ?? "";
                            codeController.text = space?.typeCode ?? "";
                            descController.text = space?.description ?? "";
                            selectedColor = space?.color ?? _presetColors[0];
                            selectedIconCode = space?.icon ?? "BIDA";
                            status = space?.statusCode ?? "ACTIVE";
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: isReadOnly
                                ? Colors.blue.withOpacity(0.2)
                                : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color:
                                    isReadOnly ? Colors.blue : Colors.orange)),
                        child: Text(isReadOnly ? "Sửa" : "Hủy",
                            style: TextStyle(
                                color: isReadOnly ? Colors.blue : Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                ],
              ),
              content: SizedBox(
                width: 550,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKeyDialog,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Icon & Color Picker
                        if (!isReadOnly) ...[
                          Center(
                            child: Container(
                              width: 80, height: 80,
                              decoration: BoxDecoration(
                                color: _getColorFromHex(selectedColor)
                                    .withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: _getColorFromHex(selectedColor),
                                    width: 2),
                              ),
                              // [SỬA] Dùng _buildIcon để hiển thị Preview
                              child: Center(
                                child: _buildIcon(
                                    _getIconDataFromCode(selectedIconCode),
                                    _getColorFromHex(selectedColor),
                                    size: 40),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text("Chọn Biểu tượng",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 60,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: _presetIcons.entries.map((entry) {
                                final isSelected =
                                    selectedIconCode == entry.key;
                                // entry.value có thể là String hoặc IconData
                                final iconData = entry.value;

                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: InkWell(
                                    onTap: () => setState(
                                        () => selectedIconCode = entry.key),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: 50, height: 50,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white.withOpacity(0.1)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        border: isSelected
                                            ? Border.all(
                                                color: Colors.white, width: 1)
                                            : null,
                                      ),
                                      // [SỬA] Dùng _buildIcon để hiển thị danh sách chọn
                                      child: Center(
                                        child: _buildIcon(
                                            iconData,
                                            isSelected
                                                ? Colors.white
                                                : Colors.grey,
                                            size: 24),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text("Chọn Màu chủ đạo",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _presetColors.map((hex) {
                              final color = _getColorFromHex(hex);
                              final isSelected = selectedColor == hex;
                              return InkWell(
                                onTap: () =>
                                    setState(() => selectedColor = hex),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white,
                                          width: isSelected ? 2 : 0)),
                                  child: isSelected
                                      ? const Icon(Icons.check,
                                          size: 16, color: Colors.white)
                                      : null,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                          const Divider(color: Colors.white10),
                          const SizedBox(height: 16),
                        ] else ...[
                          Center(
                            child: Container(
                              width: 80, height: 80,
                              decoration: BoxDecoration(
                                color: _getColorFromHex(selectedColor)
                                    .withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: _getColorFromHex(selectedColor),
                                    width: 2),
                              ),
                              // [SỬA] Dùng _buildIcon cho chế độ View
                              child: Center(
                                child: _buildIcon(
                                    _getIconDataFromCode(selectedIconCode),
                                    _getColorFromHex(selectedColor),
                                    size: 40),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // ... (Inputs: Code, Name, Desc, Status - Giữ nguyên)
                        Row(children: [
                          Expanded(
                              child: _buildDialogTextField(
                                  label: "Mã (Code)",
                                  controller: codeController,
                                  readOnly: isReadOnly,
                                  hint: "VD: BILLIARD")),
                          const SizedBox(width: 16),
                          Expanded(
                              child: _buildDialogTextField(
                                  label: "Tên Loại hình",
                                  controller: nameController,
                                  readOnly: isReadOnly,
                                  hint: "VD:BiDa",
                                  validator: (v) =>
                                      v!.isEmpty ? "Nhập tên" : null)),
                        ]),
                        const SizedBox(height: 16),
                        _buildDialogTextField(
                            label: "Mô tả",
                            controller: descController,
                            readOnly: isReadOnly,
                            hint: "Mô tả ngắn...",
                            maxLines: 2),
                        const SizedBox(height: 8),
// [SỬA] Nút Đổi Trạng Thái Riêng (Chỉ hiện khi Edit)
                        if (isEdit) ...[
                          const SizedBox(height: 8),
                          const Divider(color: Colors.white10),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Trạng thái hiện tại:",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: status == 'ACTIVE'
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.red.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Text(
                                        status == 'ACTIVE'
                                            ? "Đang hoạt động"
                                            : "Ngừng hoạt động",
                                        style: TextStyle(
                                            color: status == 'ACTIVE'
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12)),
                                  ),
                                ],
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Logic đổi trạng thái ngay lập tức (API riêng)
                                  final newStatus = status == 'ACTIVE'
                                      ? 'INACTIVE'
                                      : 'ACTIVE';
                                  _bloc.add(ChangeSpaceStatusEvent(
                                      space!.spaceId!, newStatus));
                                },
                                icon: const Icon(Icons.swap_horiz,
                                    size: 16, color: Colors.white),
                                label: const Text("Đổi trạng thái",
                                    style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                              )
                            ],
                          ),
                        ],

                        // Khi View: Chỉ hiện trạng thái text
                        if (isReadOnly) ...[
                          const SizedBox(height: 16),
                          const Text("Trạng thái",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(
                              status == 'ACTIVE'
                                  ? "Đang hoạt động"
                                  : "Ngừng hoạt động",
                              style: TextStyle(
                                  color: status == 'ACTIVE'
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                if (!isReadOnly)
                  ElevatedButton(
                    onPressed: () {
                      if (_formKeyDialog.currentState!.validate()) {
                        final newModel = SpaceModel(
                          spaceId: space?.spaceId,
                          typeCode: codeController.text,
                          typeName: nameController.text,
                          description: descController.text,
                          statusCode: status,
                          statusName: status == "ACTIVE"
                              ? "Đang hoạt động"
                              : "Ngừng hoạt động",
                          color: selectedColor,
                          icon: selectedIconCode, // Lưu key (vd: "BIDA")
                        );

                        if (isCreate) {
                          _bloc.add(CreateSpaceEvent(newModel));
                        } else {
                          _bloc
                              .add(UpdateSpaceEvent(space!.spaceId!, newModel));
                        }
                        Navigator.pop(ctx);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGlow),
                    child: Text(isCreate ? "Tạo mới" : "Lưu thay đổi",
                        style: const TextStyle(color: Colors.white)),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDialogTextField(
      {required String label,
      required TextEditingController controller,
      bool readOnly = false,
      String? hint,
      int maxLines = 1,
      String? Function(String?)? validator}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade700),
          filled: true,
          fillColor: readOnly ? Colors.transparent : AppColors.inputBackground,
          border: readOnly
              ? const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24))
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade800)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        validator: validator,
      )
    ]);
  }

  Widget _buildDialogTextFieldStatus({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
    bool isActive = false,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        readOnly: true,
        maxLines: maxLines,
        style: TextStyle(
          color: isActive ? Colors.green : Colors.grey,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade700),
          filled: true,
          fillColor: readOnly ? Colors.transparent : AppColors.inputBackground,
          border: readOnly
              ? const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24))
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: isActive
                          ? Colors.green.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2))),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        validator: validator,
      )
    ]);
  }
}
