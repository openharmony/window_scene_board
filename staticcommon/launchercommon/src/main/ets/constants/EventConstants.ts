/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Constants of events that will be registered to system.
 */
export class EventConstants {
  // system events
  public static EVENT_PACKAGE_ADDED = 'usual.event.PACKAGE_ADDED';
  public static EVENT_PACKAGE_CHANGED = 'usual.event.PACKAGE_CHANGED';
  public static EVENT_PACKAGE_REMOVED = 'usual.event.PACKAGE_REMOVED';
  public static EVENT_DYNAMIC_ICON_CHANGED = 'usual.event.DYNAMIC_ICON_CHANGED';

  // page desktop events
  public static EVENT_REQUEST_PAGEDESK_ITEM_ADD = 'launcher.event.REQUEST_PAGEDESK_ITEM_ADD'; //request add item to pageDesk
  public static EVENT_REQUEST_PAGEDESK_ITEM_UPDATE = 'launcher.event.EVENT_REQUEST_PAGEDESK_ITEM_UPDATE'; //request update item to pageDesk
  public static EVENT_REQUEST_PAGEDESK_ITEM_DELETE = 'launcher.event.REQUEST_PAGEDESK_ITEM_DELETE'; //request add item to pageDesk
  public static EVENT_REQUEST_PAGEDESK_ITEM_DELETE_BATCH = 'launcher.event.REQUEST_PAGEDESK_ITEM_DELETE_BATCH';
  public static EVENT_REQUEST_PAGEDESK_ITEM_REMOVE = 'launcher.event.REQUEST_PAGEDESK_ITEM_REMOVE';
  public static EVENT_REQUEST_PAGEDESK_ITEM_REMOVE_BATCH = 'launcher.event.REQUEST_PAGEDESK_ITEM_REMOVE_BATCH';
  public static EVENT_REQUEST_PAGEDESK_REFRESH_FINISHED = 'launcher.event.EVENT_REQUEST_PAGEDESK_REFRESH_FINISHED';
  public static EVENT_REQUEST_FORM_ITEM_ADD = 'launcher.event.REQUEST_FORM_ITEM_ADD';
  public static EVENT_REQUEST_FORM_ITEM_VISIBLE = 'launcher.event.REQUEST_FORM_ITEM_VISIBLE';
  public static EVENT_REQUEST_DESKTOP_ITEM_UNSELECT = 'launcher.event.REQUEST_DESKTOP_ITEM_UNSELECT';
  public static EVENT_BADGE_UPDATE = 'launcher.event.EVENT_BADGE_UPDATE';
  public static EVENT_REQUEST_APP_GRID_REFRESH_FINISHED = 'launcher.event.EVENT_REQUEST_APP_GRID_REFRESH_FINISHED';
  public static EVENT_SMARTDOCK_INIT_FINISHED = 'launcher.event.EVENT_SMARTDOCK_INIT_FINISHED';
  public static EVENT_REQUEST_APPGALLERY_CREATED = 'launcher.event.EVENT_REQUEST_APPGALLERY_CREATED';
  public static EVENT_LAYOUT_INIT_FINISHED = 'launcher.event.EVENT_LAYOUT_INIT_FINISHED';
  public static EVENT_REFRESH_SWIPER_PAGE = 'launcher.event.EVENT_REFRESH_SWIPER_PAGE';

  // 恢复预置布局事件
  public static EVENT_RESTORE_DESKTOP_LAYOUT = 'launcher.event.RESTORE_DESKTOP_LAYOUT';
  public static EVENT_UPDATE_CURRENT_PAGE = 'launcher.event.EVENT_UPDATE_CURRENT_PAGE';
  public static EVENT_REQUEST_DELETE_DEFAULT_CARD = 'launcher.event.EVENT_REQUEST_DELETE_DEFAULT_CARD';
  public static EVENT_REQUEST_SINGLE_DISPLAY_SWITCH_REFRESH = 'launcher.event.EVENT_REQUEST_SWITCH_REFRESH';
  public static EVENT_REQUEST_PAGEDESK_ITEM_SORT = 'launcher.event.REQUEST_PAGEDESK_ITEM_SORT';
  public static EVENT_DESKTOP_TRIM = 'launcher.event.DESKTOP_TRIM';
  public static EVENT_DESKTOP_CANT_ADD = 'launcher.event.EVENT_DESKTOP_CANT_ADD';
  public static EVENT_ADD_APP_WHEN_EXCEED_MAX_PAGE = 'launcher.event.ADD_APP_WHEN_EXCEED_MAX_PAGE';
  public static APP_INSTALL_BMS_CHANGE_EVENT = 'launcher.event.APP_INSTALL_BMS_CHANGE_EVENT';
  public static EVENT_REQUEST_APPGALLERY_FINISH = 'launcher.event.EVENT_REQUEST_APPGALLERY_FINISH';
  public static EVENT_DESKTOP_PASTE = 'launcher.event.DESKTOP_PASTE';
  public static EVENT_RESET_ALL_SELECT_STATUS = 'launcher.event.RESET_ALL_SELECT_STATUS';
  public static EVENT_CLEAR_SELECT_ITEMS = 'launcher.event.CLEAR_SELECT_ITEMS';
  public static EVENT_OPEN_APPLICATION = 'launcher.event.OPEN_APPLICATION';
  public static EVENT_UNINSTALL_APPLICATION = 'launcher.event.UNINSTALL_APPLICATION';
  public static EVENT_BATCH_UPDATE_ITEM_POSITION = 'launcher.event.BATCH_UPDATE_ITEM_POSITION';
  public static EVENT_SHOW_NEXT_PATE = 'launcher.event.SHOW_NEXT_PAGE';
  public static EVENT_ADD_MIDDLE_PAGE = 'launcher.event.ADD_MIDDLE_PAGE';
  public static EVENT_DELETE_NOT_UNINSTALL_APP = 'launcher.event.DELETE_NOT_UNINSTALL_APP';
  public static EVENT_DELETE_APP_AUTO_ALIGN = 'launcher.event.DELETE_APP_AUTO_ALIGN';
  public static EVENT_ANNOUNCED_SWIPER_PAGE = 'launcher.event.ANNOUNCED_SWIPER_PAGE';
  public static EVENT_AUTO_ALIGN_AFTER_UNINSTALL = 'launcher.event.AUTO_ALIGN_AFTER_UNINSTALL';
  public static EVENT_OUTER_DELETE_APP_INFO = 'launcher.event.OUTER_DELETE_APP_INFO';
  public static EVENT_OUTER_DELETE_SHORTCUT = 'launcher.event.OUTER_DELETE_SHORTCUT';
  public static EVENT_UPDATE_GIRD_ITEM_POOL_STATUS = 'launcher.event.EVENT_UPDATE_GIRD_ITEM_POOL_STATUS';

  // smartdock events
  public static EVENT_REQUEST_DOCK_ITEM_ADD = 'launcher.event.REQUEST_DOCK_ITEM_ADD'; //request add item to smartDock
  public static EVENT_REQUEST_DOCK_CTRL_Q_CALLBACK = 'usual.event.REQUEST_DOCK_CTRL_Q_CALLBACK'; //request to trigger ctrl+q callback of smartdock
  public static EVENT_PC_HIDE_DOCK_CALLBACK = 'launcher.event.PC_HIDE_DOCK_CALLBACK';
  public static EVENT_PC_SNAPSHOT_STYLE_CHANGE_CALLBACK = 'launcher.event.PC_SNAPSHOT_STYLE_CHANGE_CALLBACK';
  public static readonly EVENT_RESET_HIDE_DOCK_AFTER_POPUP_STATE_CALLBACK: string = 'launcher.event.RESET_HIDE_DOCK_AFTER_POPUP_STATE';
  public static EVENT_VM_SWITCH_TO_DESKTOP_CALLBACK = 'usual.event.VM_SWITCH_TO_DESKTOP_CALLBACK';
  public static EVENT_REQUEST_RESIDENT_DOCK_ITEM_UPDATE = 'launcher.event.EVENT_REQUEST_RESIDENT_DOCK_ITEM_UPDATE'; //request update item to smartdock
  public static EVENT_REQUEST_RESIDENT_DOCK_ITEM_DELETE = 'launcher.event.REQUEST_DOCK_ITEM_DELETE'; //request delete resident item
  public static EVENT_DELIVER_APP_ITEM_REMOVE = 'launcher.event.DELIVER_APP_ITEM_REMOVE'; // request remove deliver app item
  public static EVENT_REQUEST_RESIDENT_DOCK_ITEM_REMOVE = 'launcher.event.REQUEST_DOCK_ITEM_REMOVE'; //request remove resident item
  public static EVENT_PC_DOCK_ITEM_CHANGE = 'EVENT_PC_DOCK_ITEM_CHANGE';
  public static EVENT_PC_DOCK_DRAG_CHANGE = 'EVENT_PC_DOCK_DRAG_CHANGE';
  public static EVENT_PC_DOCK_ITEM_HOVER_CHANGE = 'EVENT_PC_DOCK_ITEM_HOVER_CHANGE';
  public static EVENT_PC_DOCK_VISABLE_CHANGE = 'EVENT_PC_DOCK_VISABLE_CHANGE';
  public static EVENT_REQUEST_RESIDENT_DOCK_ITEM_REFRESH = 'launcher.event.RECENT_DOCK_ITEM_REFRESH'; //request refresh resident item
  public static EVENT_REQUEST_RESIDENT_DOCK_NOT_INSTALL_ITEM_DELETE = 'launcher.event.RESIDENT_DOCK_NOT_INSTALL_ITEM_DELETE'; //request delete resident NOT INSTALL item
  public static EVENT_REQUEST_RECENT_DOCK_ITEM_DELETE = 'launcher.event.RECENT_DOCK_ITEM_DELETE'; //request delete recent item
  public static EVENT_REQUEST_RECENT_LOCK_ITEM_DELETE = 'launcher.event.RECENT_LOCK_ITEM_DELETE'; //request delete recent item
  public static EVENT_REQUEST_IS_RECYCLE_BIN_EMPTY = 'isRecycleBinEmpty';
  public static EVENT_REQUEST_REFRESH_DOCK_RECYCLE_BIN_ICON = 'refreshRecycleBin';
  public static EVENT_SUGGEST_MENU_REMOVED = 'usual.event.SUGGEST_MENU_REMOVED';
  public static EVENT_CONTAINER_SESSION_ADDED = 'usual.event.CONTAINER_SESSION_ADDED';
  public static EVENT_REQUEST_PAGEDESK_FORM_ITEM_ADD = 'launcher.event.EVENT_REQUEST_PAGEDESK_FORM_ITEM_ADD';
  public static EVENT_REQUEST_PAGEDESK_FORM_ITEM_DELETE = 'launcher.event.EVENT_REQUEST_PAGEDESK_FORM_ITEM_DELETE';
  public static EVENT_REQUEST_PAGEDESK_FORM_ITEM_DELETE_BY_INTELLIGENT = 'launcher.event.EVENT_REQUEST_PAGEDESK_FORM_ITEM_DELETE_BY_INTELLIGENT';
  public static EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH = 'EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH'; // pageDesktop light refresh
  public static EVENT_REQUEST_PAGEDESK_RELOAD_REFRESH = 'EVENT_REQUEST_PAGEDESK_RELOAD_REFRESH'; // pageDesktop reload refresh
  public static EVENT_REQUEST_SHORTCUT_ITEM_DELETE = 'launcher.event.REQUEST_SHORTCUT_ITEM_DELETE'; //request delete resident item
  public static EVENT_REQUEST_APP_DOUBLE_CLICK = 'launcher.event.REQUEST_APP_DOUBLE_CLICK';
  public static EVENT_REQUEST_FALL_BOX_HIDE = 'launcher.event.REQUEST_FALL_BOX_HIDE';
  /**
   * outer pageDesktop refresh
   */
  public static EVENT_REQUEST_OUTER_PAGEDESK_LIGHT_REFRESH = 'EVENT_REQUEST_OUTER_PAGEDESK_LIGHT_REFRESH';
  public static EVENT_REQUEST_INNER_PAGEDESK_LIGHT_REFRESH = 'EVENT_REQUEST_INNER_PAGEDESK_LIGHT_REFRESH';
  public static EVENT_REQUEST_PAGEDESK_ADD_TO_FOLDER = 'EVENT_REQUEST_PAGEDESK_ADD_TO_FOLDER';
  public static readonly EVENT_DOCK_DISPLAY_VISIBLE_CHANGE: string = 'usual.event.DOCK_DISPLAY_VISIBLE_CHANGE';
  public static EVENT_DOCK_HOVER_STATE_CHANGE: string = 'usual.event.DOCK_HOVER_STATE_CHANGE';
  public static EVENT_DOCK_VISIBLE_ANIM: string = 'usual.event.DOCK_VISIBLE_ANIM'; // 外模块隐藏或显示dock
  public static readonly EVENT_DOCK_POPUP_VISIBLE_CHANGE: string = 'usual.event.DOCK_POPUP_VISIBLE_CHANGED'; // dock preview窗
  public static readonly EVENT_DOCK_MENU_VISIBLE_CHANGE: string = 'usual.event.DOCK_MENU_VISIBLE_CHANGED'; // dock menu

  // bigfolder events
  public static EVENT_FOLDER_ITEM_REMOVE = 'usual.event.EVENT_FOLDER_ITEM_REMOVE';
  public static EVENT_FOLDER_PACKAGE_REMOVED = 'usual.event.FOLDER_PACKAGE_REMOVED';
  public static EVENT_FOLDER_PACKAGE_REMOVED_BATCH = 'usual.event.FOLDER_PACKAGE_REMOVED_BATCH';
  public static EVENT_FOLDER_ITEM_UPDATE = 'usual.event.FOLDER_ITEM_UPDATE';
  public static EVENT_FOLDER_ITEM_ADD = 'usual.event.FOLDER_ITEM_ADD';
  public static EVENT_DRAG_ITEM_FROM_FOLDER_UNINSTALL = 'usual.event.DRAG_ITEM_FROM_FOLDER_UNINSTALL';
  public static EVENT_FOLDER_APP_PACKAGE_CHANGED = 'usual.event.FOLDER_APP_PACKAGE_CHANGED';
  public static EVENT_FOLDER_REFRESH_VIEW = 'usual.event.FOLDER_REFRESH_VIEW';
  public static EVENT_FOLDER_UPDATE_LAYOUT = 'usual.event.FOLDER_UPDATE_LAYOUT';
  public static EVENT_FOLDER_DELETE_ALL_NODE_CACHE = 'usual.event.FOLDER_DELETE_ALL_NODE_CACHE';

  // folder open component events
  public static EVENT_FOLDER_CLOSE_RENAME_INPUT = 'usual.event.EVENT_FOLDER_CLOSE_RENAME_INPUT';
  // folder close component events
  public static EVENT_FOLDER_CLOSING = 'usual.event.EVENT_FOLDER_CLOSING';
  // gesture navigation events
  public static EVENT_NAVIGATOR_BAR_STATUS_CHANGE = 'usual.event.NAVIGATOR_BAR_STATUS_CHANGE';

  public static EVENT_AI_BAR_STATUS_CHANGE = 'usual.event.AI_BAR_STATUS_CHANGE';
  public static SYSTEM_BAR_CHANGE = 'usual.event.SYSTEM_BAR_CHANGE';
  public static EVENT_APP_DOCK_VISIBILITY_CHANGE = 'usual.event.APP_DOCK_VISIBILITY_CHANGE';
  public static EVENT_GESTURE_NAVIGATION_HIDE_TEXT_INPUT = 'usual.event.GESTURE_NAVIGATION_HIDE_TEXT_INPUT';

  // desktop icon menu event when long pressing
  public static EVENT_DESKTOP_MENU_EVENT = 'usual.event.DESKTOP_MENU_EVENT';

  // folder icon menu event when long pressing
  public static EVENT_FOLDER_MENU_EVENT = 'usual.event.FOLDER_MENU_EVENT';

  // start drag item event
  public static EVENT_EDIT_MODE_START_DRAG_ITEM = 'usual.event.EDIT_MODE_START_DRAG_ITEM';
  public static EVENT_EDIT_MODE_EXIT = 'usual.event.EVENT_EDIT_MODE_EXIT';

  // desktop mode change
  public static EVENT_DESKTOP_MODE_CHANGE = 'usual.event.EVENT_DESKTOP_MODE_CHANGE';

  // form events
  public static EVENT_REQUEST_JUMP_TO_FORM_VIEW = 'launcher.event.EVENT_REQUEST_JUMP_TO_FORM_VIEW';
  public static EVENT_REQUEST_RECOMMEND_FORM_ADD = 'launcher.event.EVENT_REQUEST_RECOMMEND_FORM_ADD';
  public static EVENT_REQUEST_RECOMMEND_FORM_UPDATE = 'launcher.event.EVENT_REQUEST_RECOMMEND_FORM_UPDATE';
  public static EVENT_REQUEST_RECOMMEND_FORM_DELETE = 'launcher.event.EVENT_REQUEST_RECOMMEND_FORM_DELETE';
  public static EVENT_REQUEST_FORM_RECYCLE = 'launcher.event.REQUEST_FORM_RECYCLE';
  public static EVENT_REQUEST_SET_OPERATE_STACK_ENABLED = 'launcher.event.REQUEST_SET_OPERATE_STACK_ENABLED';

  // form stack events
  public static EVENT_REQUEST_FORM_STACK_DELETE = 'launcher.event.EVENT_REQUEST_FORM_STACK_UPDATE';
  public static EVENT_FORM_STACK_ITEM_STATUS_CHANGE_EVENT = 'launcher.event.FORM_STACK_ITEM_STATUS_CHANGE_EVENT';

  public static EVENT_FORM_STACK_ITEM_DRAG_LEAVE = 'launcher.event.FORM_STACK_ITEM_DRAG_LEAVE';

  public static EVENT_FORM_STACK_LEFT_SLIDE_DELETE = 'launcher.event.FORM_STACK_LEFT_SLIDE_DELETE';
  public static EVENT_FORM_STACK_CLICK_DELETE = 'launcher.event.FORM_STACK_CLICK_DELETE';
  public static EVENT_FORM_STACK_SLIDE_CARD = 'launcher.event.FORM_STACK_SLIDE_CARD';
  public static EVENT_CLEAR_DELETE_CARDS = 'launcher.event.CLEAR_DELETE_CARDS';

  // outer card events
  public static EVENT_REQUEST_OUTER_CARD_DELETE = 'launcher.event.EVENT_REQUEST_OUTER_CARD_DELETE';
  public static EVENT_REQUEST_OUTER_AI_CARD_DELETE = 'launcher.event.EVENT_REQUEST_OUTER_AI_CARD_DELETE';
  public static EVENT_REQUEST_OUTER_MENU_CLOSE = 'launcher.event.EVENT_REQUEST_OUTER_MENU_CLOSE';
  public static EVENT_REQUEST_OUTER_MENU_OPEN = 'launcher.event.EVENT_REQUEST_OUTER_MENU_OPEN';
  public static EVENT_REQUEST_OUTER_CARD_DRAG_END = 'launcher.event.EVENT_REQUEST_OUTER_CARD_DRAG_END';

  // outer stack menu events
  public static EVENT_REQUEST_OUTER_STACK_DRAG_END = 'launcher.event.EVENT_REQUEST_OUTER_STACK_DRAG_END';
  public static EVENT_REQUEST_OUTER_STACK_EXPAND = 'launcher.event.EVENT_REQUEST_OUTER_STACK_EXPAND';

  // animation event
  public static EVENT_ANIMATION_START_APPLICATION = 'launcher.event.EVENT_ANIMATION_START_APPLICATION';
  public static EVENT_ANIMATION_CLOSE_APPLICATION = 'launcher.event.EVENT_ANIMATION_CLOSE_APPLICATION';

  // screen lock event
  public static EVENT_SCREEN_LOCK = 'common.event.LOCK_SCREEN';
  public static EVENT_SCREEN_LOCK_NEW = 'usual.event.SCREEN_LOCKED';
  public static EVENT_SCREEN_UNLOCK = 'common.event.UNLOCK_SCREEN';
  public static EVENT_SCREEN_UNLOCK_NEW = 'usual.event.SCREEN_UNLOCKED';

  // systemUI panel status event
  public static EVENT_SYSTEMUI_PANEL_STATUS_CHANGED = 'COMMON_EVENT_SYSTEMUI_PANEL_STATUS_CHANGED';

  // screen ID change
  public static EVENT_SCREEN_ID_CHANGE = 'common.event.SCREEN_ID_CHANGE';

  // float show events
  public static EVENT_FLOAT_ON_FOCUS = 'launcher.event.EVENT_FLOAT_ON_FOCUS';

  // Desktop or dock layout change event
  public static EVENT_LAYOUT_CHANGE_EVENT = 'launcher.event.LAYOUT_CHANGE';
  // close pc dock popup
  public static EVENT_PC_DOCK_CLOSE_POPUP = 'launcher.event.PC_DOCK_CLOSE_POPUP';
  // pad pc dock small folder convert to big start convert value change
  public static EVENT_PC_DOCK_CONVERT_TO_BIG_STATUS_CHANGE = 'launcher.event.PC_DOCK_CONVERT_TO_BIG_STATUS_CHANGE';
  // pad pc dock small folder convert to big folder i change
  public static EVENT_PC_DOCK_CONVERT_TO_BIG_FOLDER_ID_CHANGE = 'launcher.event.PC_DOCK_CONVERT_TO_BIG_FOLDER_ID_CHANGE';
  // close pc dock menu and popup
  public static EVENT_CLOSE_DOCK_MENU_AND_POPUP = 'launcher.event.CLOSE_DOCK_MENU_AND_POPUP';

  // intelligent event
  public static EVENT_REMOVE_INTELLIGENT_CARD = 'REMOVE_INTELLIGENT_CARD';
  public static EVENT_RESUME_INTELLIGENT_CARD = 'RESUME_INTELLIGENT_CARD';
  public static EVENT_INTELLIGENT_CARD_DRAG_ENTER = 'INTELLIGENT_CARD_DRAG_ENTER';
  public static EVENT_INTELLIGENT_CARD_DRAG_FAIL = 'INTELLIGENT_CARD_DRAG_FAIL';
  public static EVENT_INTELLIGENT_SIGN_STATUS = 'INTELLIGENT_SIGN_STATUS';
  public static EVENT_INTELLIGENT_ADD_CARD = 'INTELLIGENT_CARD_ADD';
  public static EVENT_INTELLIGENT_ADD_CARD_CALLBACK = 'INTELLIGENT_CARD_ADD_CALLBACK';
  public static INTELLIGENT_GET_FROM_ID_LIST_CALLBACK = 'INTELLIGENT_GET_FROM_ID_LIST_CALLBACK';

  public static EVENT_INIT_DEFAULT_FILEFOLDER = 'INIT_DEFAULT_FILEFOLDER';

  // edit mode drop event
  public static EVENT_PAGEDESK_DROP_FINISHED = 'launcher.event.PAGEDESK_DROP_FINISHED';
  // edit mode item click
  public static EVENT_EDIT_MODE_TOUCH_DOWN_ITEM = 'launcher.event.EDIT_MODE_TOUCH_DOWN_ITEM';
  // 关闭文件夹添加对话框
  public static EVENT_CLOSE_FOLDER_ADD_DIALOG = 'launcher.event.close_folder_add_dialog';

  public static EVENT_UPDATE_PAGE_FOCUS = 'launcher.event.EVENT_UPDATE_PAGE_FOCUS';

  public static EVENT_FOLDER_DRAG_END = 'launcher.event.EVENT_FOLDER_DRAG_END';
  // small folder event
  public static EVENT_GRAY_PACKAGE_CHANGED = 'launcher.event.GRAY_PACKAGE_CHANGE';
  public static EVENT_REFRESH_ALL_SMALL_FOLDER_IMAGE = 'launcher.event.EVENT_REFRESH_ALL_SMALL_FOLDER_IMAGE';

  public static EVENT_UNINSTALL_ITEM_FROM_FOLDER = 'launcher.event.UNINSTALL_ITEM_FROM_FOLDER';

  public static EVENT_INIT_APPLIST_FINISH = 'launcher.event.init_applist_finish';

  /**
   * 状态栏调整后的工作区位置变更
   */
  public static readonly EVENT_WORKSPACE_POSITION_CHANGE = 'launcher.event.WORKSPACE_POSITION_CHANGE';

  // preview setting changed event
  public static EVENT_PREVIEW_STYLE_CHANGED = 'launcher.event.EVENT_PREVIEW_STYLE_CHANGED';

  // 编辑模式切换事件
  public static EVENT_CHANGE_DESKTOP_MODE = 'launcher.event.CHANGE_DESKTOP_MODE';

  // 编辑模式切换名称通知事件
  public static EVENT_CHANGE_DESKTOP_MODE_NAME = 'launcher.event.CHANGE_DESKTOP_MODE_NAME';

  // 桌面显示页面数切换通知事件
  public static EVENT_CHANGE_DESKTOP_DISPLAY_COUNT = 'launcher.event.CHANGE_DESKTOP_DISPLAY_COUNT';

  //super fold status change
  public static EVENT_SUPER_FOLD_STATUS_CHANGE = 'launcher.event.super_fold_status_change';

  // 编辑模式切换 通知动画事件
  public static EVENT_CHANGE_DESKTOP_MODE_ANIMATE = 'launcher.event.CHANGE_DESKTOP_MODE_ANIMATE';

  // 编辑模式切换 通知改变布局事件
  public static EVENT_CHANGE_DESKTOP_MODE_LAYOUT = 'launcher.event.CHANGE_DESKTOP_MODE_LAYOUT';

  // 编辑模式切换 进入编辑模式动画执行完毕事件
  public static EVENT_CHANGE_ENTER_EDIT_MODE_ANIMATION_FINISH = 'launcher.event.ENTER_EDIT_MODE_ANIMATION_FINISH';

  // 编辑模式切换 进入退出编辑模式动画执行完毕事件
  public static EVENT_CHANGE_CHANGE_EDIT_MODE_ANIMATION_FINISH = 'launcher.event.CHANGE_EDIT_MODE_ANIMATION_FINISH';

  // 图标编辑页面变化事件
  public static EVENT_APP_ICON_EDIT_CHANGED = 'launcher.event.APP_ICON_EDIT_CHANGED';

  // 图标编辑打开UIExtension事件
  public static EVENT_OPEN_ICON_EDIT_PAGE = 'launcher.event.OPEN_ICON_EDIT_PAGE';

  // 更新桌面中轴区大小
  public static EVENT_SUPER_FOLD_CONFIG_CHANGE = 'launcher.event.super.fold.config.change';

  // change desktop focus event
  public static EVENT_REQUEST_DESKTOP_FOCUS_CHANGE = 'launcher.event.DESKTOP_FOCUS_CHANGE';

  // desktop file event
  public static EVENT_REQUEST_PAGEDESK_FILE_REFRESH = 'launcher.event.PAGEDESK_FILE_REFRESH';

  // desktop file item icon refresh
  public static EVENT_REQUEST_PAGEDESK_FILE_ITEM_ICON_REFRESH = 'launcher.event.PAGEDESK_FILE_ITEM_ICON_REFRESH';

  // desktop item select
  public static EVENT_REQUEST_PAGEDESK_ITEM_SELECTED = 'launcher.event.PAGEDESK_ITEM_SELECTED';

  // three finger tap
  public static readonly EVENT_THREE_FINGERS_TAP: string = 'usual.event.THREE_FINGERS_TAP';

  // BMS 资源更新通知
  public static readonly EVENT_BUNDLE_RESOURCES_CHANGED: string = 'usual.event.BUNDLE_RESOURCES_CHANGED';

  // BMS 快捷方式更新通知
  static readonly EVENT_SHORTCUT_CHANGED = 'usual.event.SHORTCUT_CHANGED';

  // 版本校验完成 图标刷新
  public static readonly EVENT_REFRESH_ICON_IMAGE: string = 'launcher.event.REFRESH_ICON_IMAGE';

  // 版本校验完成 快捷图标刷新
  public static readonly EVENT_REFRESH_SHORTCUT_IMAGE: string = 'launcher.event.REFRESH_SHORTCUT_IMAGE';

  // 退出动效
  public static readonly EVENT_IN_APP_EXIT: string = 'launcher.event.IN_APP_EXIT';

  // 横屏退出
  public static readonly EVENT_APP_EXIT_LANDSCAPE: string = 'launcher.event.APP_EXIT_LANDSCAPE';

  // 单手模式底部导航发cancel事件
  public static readonly EVENT_NAV_BAR_GESTURE_CANCEL: string = 'launcher.event.NAV_BAR_GESTURE_CANCEL';

  /**
   * 大桌面上下文
   */
  public static readonly EVENT_DESKTOP_CONTEXT: string = 'desktopContext';

  /**
   * 强制关闭所有系统弹窗(PC兜底)
   */
  public static readonly EVENT_FORCE_CLOSE_ALL_SYS_DIALOG: string = 'usual.event.FORCE_CLOSE_ALL_SYS_DIALOG';

  /**
   * BMS 资源更新通知, 资源变更的类型
   */
  public static readonly BUNDLE_RESOURCE_CHANGE_TYPE_SYSTEM_LANGUAGE_CHANGE: number = 0x00000001;
  public static readonly BUNDLE_RESOURCE_CHANGE_TYPE_SYSTEM_THEME_CHANGE: number = 0x00000010;
  public static readonly BUNDLE_RESOURCE_CHANGE_TYPE_SYSTEM_COLOR_MODE_CHANGE: number = 0x00000020;
  public static readonly BUNDLE_RESOURCE_CHANGE_TYPE_SYSTEM_USER_ID_CHANGE: number = 0x00000030;

  // 编辑模式新增删除空白页事件
  public static EDIT_BLANK_PAGE_IN_EDIT_MODE = 'launcher.event.EDIT_BLANK_PAGE_IN_EDIT_MODE';

  // 编辑模式拖拽空白页事件
  public static END_DRAG_PAGE_IN_EDIT_MODE = 'launcher.event.END_DRAG_PAGE_IN_EDIT_MODE';

  // 编辑模式拖拽空白页事件
  public static PRE_DRAG_PAGE_IN_EDIT_MODE = 'launcher.event.PRE_DRAG_PAGE_IN_EDIT_MODE';
  public static readonly CONTEXT_KEY = 'desktopContext';
  public static readonly CLICK_BACK_STATUS = 'clickBackStatus';
  public static readonly OLD_NAVIGATION_TYPE_KEY = 'secure_gesture_navigation';
  // 创建堆叠通知事件
  public static readonly CREATE_FORM_STACK_NOTIFY_EVENT = 'CREATE_FORM_STACK_NOTIFY_EVENT';
  // 修改缓存通知
  public static readonly CHANGE_CURRENT_LAYOUT_CACHE_DATA = 'changeCurrentLayoutCacheDataEvent';
  // homeKeyOption 事件
  public static readonly HOME_KEY_INPUT = 'homeKeyOption';
  // 动态更新弹窗位置
  public static EVENT_UPDATE_DIALOG_POSITION = 'launcher.event.event_update_dialog_position';
  // 图标资源更新
  public static EVENT_ICON_RESOURCE_REFRESH = 'launcher.event.EVENT_ICON_RESOURCE_REFRESH';
  // 打断翻页滑动
  public static EVENT_BREAK_SLIDE_SWIPER_PAGE = 'launcher.event.BREAK_SLIDE_SWIPER_PAGE';
  // 三折叠桌面开合更新屏幕数据
  public static EVENT_UPDATE_SCREEN_DATA = 'launcher.event.UPDATE_SCREEN_DATA';
  // 切换主题时对首页所有大文件截图
  public static EVENT_CHANGE_THEME_BIG_FOLDER_PIC = 'launcher.event.CHANGE_THEME_BIG_FOLDER_PIC';

  /**
   * 切主题桌面图标刷新完成通知主题事件
   */
  public static EVENT_FINISH_SWITCH_APP_ICON = 'event_finish_switch_app_icon';

  /**
   * 文件夹推荐弹框打开关闭事件
   */
  public static EVENT_FOLDER_ADD_SHEET_REQUEST_OPEN = 'EVENT_FOLDER_ADD_SHEET_REQUEST_OPEN';
  public static EVENT_FOLDER_ADD_SHEET_REQUEST_CLOSE = 'EVENT_FOLDER_ADD_SHEET_REQUEST_CLOSE';
  public static EVENT_AI_CARDNODE_UPDATE = 'EVENT_AI_CARDNODE_UPDATE';
};

export default EventConstants;