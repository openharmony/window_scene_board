/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import {
  LogDomain,
  LogHelper,
  SingletonHelper,
} from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import {
  AccessibilityManager,
  ApsUtils,
  GlobalContext,
  localEventManager
} from '@ohos/frameworkwrapper';
import { scbStatusBarStatusManager, StatusBarType } from '@ohos/systemuicommon';
import dragController from '@ohos.arkui.dragController';
import EditModeStyleConstants from '../common/constants/EditModeStyleConstants';
import IconEditPageConstants from '../common/constants/IconEditPageConstants';
import { EditModeViewEvent } from '../viewmodel/EditModeViewEvent';
import { EditModeViewAnimate } from '../viewmodel/EditModeViewAnimate';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import {
  DesktopMode,
  EditModeConstants,
  GridLayoutItemInfo,
  HiEditModeDataExitType,
  HiEditModeEventUtils,
  EventConstants,
  CommonConstants,
  AppStatus,
  AppInstallUtils,
  vibratorMgr,
  FormCenterViewManager,
  EditModeUtils,
  EditModePageStaticData,
  StyleConstants,
  DesktopUtils,
  AppItemInfo,
} from '@ohos/launchercommon';
import { EditModeGridSwiperViewData } from '../data/EditModeGridSwiperViewData';
import { EditModeSingePageViewData } from '../data/EditModeSingePageViewData';
import { EditModeWallpaperViewData } from '../data/EditModeWallpaperViewData';
import { IconEditWantData } from '../data/IconEditWantData';
import { EditModeExtensionData } from '../data/EditModeExtensionData';
import lazy { OuterButtonDockData } from '../data/OuterButtonDockData';
import { editModeUIExtensionViewModel } from '../../uiExtension/viewmodel/EditModeUIExtensionViewModel';
import { editModeDockViewModel } from '../viewmodel/EditModeDockViewModel';
import lazy OuterEditConstants from '../common/constants/OuterEditConstants';
import { launcherVisualEffectMgr } from '@ohos/launchercommon/Index';
import { MoveItem } from '@ohos/launchercommon/src/main/ets/bean/MoveItem';
// import apsManager from '@hms.graphic.apsManager';

const TAG: string = 'EditModeViewManager';
const ICONEDIT_BUTTON_ID: string = 'editModeDockButton2';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 编辑模式管理类
 */
export class EditModeViewManager {
  private editModeGridSwiperViewData: EditModeGridSwiperViewData;
  private editModeSingePageViewData: EditModeSingePageViewData;
  private editModeWallpaperViewData: EditModeWallpaperViewData;
  private editModeEvent: EditModeViewEvent;
  private editModeAnimate: EditModeViewAnimate;
  private iconEditWantData: IconEditWantData;
  private editModeExtensionData: EditModeExtensionData;
  private isInEditMode: boolean = false;

  constructor() {
    this.editModeGridSwiperViewData = new EditModeGridSwiperViewData();
    this.editModeSingePageViewData = new EditModeSingePageViewData();
    this.editModeWallpaperViewData = new EditModeWallpaperViewData();
    this.editModeEvent = new EditModeViewEvent();
    this.editModeAnimate = new EditModeViewAnimate();
    this.iconEditWantData = new IconEditWantData();
    this.editModeExtensionData = new EditModeExtensionData();
  }

  /**
   * 获取编辑模式IconEditWantData
   *
   * @returns IconEditWantData
   */
  public getIconEditWantData(): IconEditWantData {
    return this.iconEditWantData;
  }

  /*
   * 获取编辑模式UI事件类
   *
   * @returns EditModeViewEvent
   */
  public getEditModeViewEvent(): EditModeViewEvent {
    return this.editModeEvent;
  }

  /**
   * 获取编辑模式按钮字体尺寸
   *
   * @returns OuterButtonDockData
   */
  public getOuterButtonDockData(): OuterButtonDockData | undefined {
    return undefined;
  }

  /*
   * 获取编辑模式UI动效类
   *
   * @returns EditModeViewAnimate
   */
  public getEditModeViewAnimate(): EditModeViewAnimate {
    return this.editModeAnimate;
  }

  /**
   * 获取编辑模式GridSwiper视图状态对象
   *
   * @returns EditModeGridSwiperViewData
   */
  public getEditModeGridSwiperViewData(): EditModeGridSwiperViewData {
    return this.editModeGridSwiperViewData;
  }

  /**
   * 获取编辑模式EditModeExtensionData对象
   *
   * @returns EditModeExtensionData
   */
  public getEditModeExtensionData(): EditModeExtensionData {
    return this.editModeExtensionData;
  }

  /**
   * 获取编辑模式SingePage视图状态对象
   *
   * @returns EditModeSingePageViewData
   */
  public getEditModeSingePageViewData(): EditModeSingePageViewData {
    return this.editModeSingePageViewData;
  }

  /**
   * 获取编辑模式Wallpaper视图状态对象
   *
   * @returns EditModeWallpaperViewData
   */
  public getEditModeWallpaperViewData(): EditModeWallpaperViewData {
    return this.editModeWallpaperViewData;
  }

  /**
   * 是否打开了编辑模式的UIExtension
   *
   * @returns 是否打开了编辑模式的UIExtension
   */
  public isShowUIExtension(): boolean {
    return this.editModeExtensionData.isShowUIExtension();
  }

  /**
   * 打开UIExtension
   */
  public openUIExtension(): void {
    this.editModeExtensionData.setShowUIExtension(true);
    editModeUIExtensionViewModel.sendShowEvent();
    launcherVisualEffectMgr.setShowUIExtension(true);
  }

  /**
   * 退出UIExtension方法
   *
   * @param isExitEditMode 是否退出编辑模式
   * @param animation 是否执行动画
   */
  public exitUIExtension(isExitEditMode: boolean, animation?: boolean): void {
    // 图标编辑页面才有这个动效
    if (this.iconEditWantData.getExtensionWant()?.abilityName === IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME) {
      new EditModeViewAnimate().playExtensionPage(false);
      GlobalContext.getContext()?.eventHub.emit(EventConstants.EVENT_OPEN_ICON_EDIT_PAGE, false);
      if (!isExitEditMode) {
        log.showInfo('exitUIExtension not is exit edit mode');
        // 不退出编辑模式，显示编辑模式的壁纸蒙版、文件夹背板
        editModeManager.getEditModeWallpaperState().setShowWallpaperView(true);
        // 无障碍模式下从图标编辑页返回，主动聚焦至图标按钮上
        const isAccessibilityMode = AppStorage.get<boolean>('isAccessibilityMode') as boolean ?? false;
        if (isAccessibilityMode) {
          const accessibilityManager = AccessibilityManager.getInstance();
          accessibilityManager.requestFocusForAccessibility(ICONEDIT_BUTTON_ID, 'requestFocusFromExitIconEditPage');
        }
      }
    }
    if (animation) {
      // 当transition挂在子节点时、控制父节点的上下树只会触发子节点的上树动画、
      // 因此这里得给父节点的下树过程添加动画、这样就可以触发子节点的下树动画、具体的动画时间以子节点自身为准
      // 这里的500代表父节点的下树时长、取的子节点的最大动画时间  
      animateTo({ duration: 500 }, () => {
        this.editModeExtensionData.setShowUIExtension(false);
        launcherVisualEffectMgr.setShowUIExtension(false);
      });
    } else {
      this.editModeExtensionData.setShowUIExtension(false);
      launcherVisualEffectMgr.setShowUIExtension(false);
    }
    // 退出编辑模式
    if (isExitEditMode) {
      editModeManager.changeDesktopMode(DesktopMode.NORMAL_MODE, HiEditModeDataExitType.EXIT_OK);
    }
  }

  /**
   * 进入退出编辑模式主体(背板)缩放动画
   *
   * @param isEditMode 是否为编辑模式
   */
  public onDesktopModeAnimateChange(isEditMode: boolean): void {
    this.isInEditMode = isEditMode;
    /*let apsSceneName = isEditMode ? apsManager.SceneAnimation.EDITMODE_ENTER : apsManager.SceneAnimation.EDITMODE_EXIT;
    // 桌面进入退出编辑模式aps锁帧投票（产品CCM定制），StyleConstants.DEFAULT_1表示场景开始
    ApsUtils.setApsScene(apsSceneName, StyleConstants.DEFAULT_1);*/
    if (isEditMode) {
      HiEditModeEventUtils.startEnterPerformanceTrack();
      this.vibratorOfEnterEditMode();
      // 显示singlePage背景
      editModeManager.getEditModeViewState().setShowEditModeView(true);
      editModeManager.getEditModeWallpaperState().setShowWallpaperView(true);
      // 编辑模式文件夹背板透明度变化动效开始前上树，确保动效完整
      editModeManager.getEditModeFolderViewData().isFolderExtraBackGroundShow.value = true;
    } else {
      HiEditModeEventUtils.startExitPerformanceTrack();
    }

    this.editModeAnimate.playEnterExitAnimate(isEditMode).finally(() => {
      // 兼容打断场景 动效结束后判断实际状态而不是传入值
      if (!isEditMode && !this.isInEditMode) {
        HiEditModeEventUtils.endExitPerformanceTrack();
        // 隐藏singlePage背景
        editModeManager.getEditModeViewState().setShowEditModeView(false);
        editModeManager.getEditModeWallpaperState().setShowWallpaperView(false);
        // 编辑模式文件夹背板透明度变化动效结束后再下树，确保动效完整
        editModeManager.getEditModeFolderViewData().isFolderExtraBackGroundShow.value = false;
        log.showInfo('exit editMode.');
      } else {
        HiEditModeEventUtils.endEnterPerformanceTrack();
        log.showInfo('enter editMode.');
        // 通知进入编辑模式动画执行完毕
        GlobalContext.getContext()?.eventHub.emit(EventConstants.EVENT_CHANGE_ENTER_EDIT_MODE_ANIMATION_FINISH);
      }
      GlobalContext.getContext()?.eventHub.emit(EventConstants.EVENT_CHANGE_CHANGE_EDIT_MODE_ANIMATION_FINISH);
      // 桌面进入退出编辑模式aps锁帧投票（产品CCM定制）结束，StyleConstants.DEFAULT_0表示场景结束
      // ApsUtils.setApsScene(apsSceneName, StyleConstants.DEFAULT_0);
    });
  }

  /**
   * 处理编辑模式状态切换
   */
  public onDesktopModeChange(): void {
    let isEditMode: boolean = editModeManager.isInEditMode();
    if (isEditMode) {
      // 隐藏状态栏
      scbStatusBarStatusManager.hideStatusBar(undefined, StatusBarType.TYPE_MAIN_PHONE_LAUNCHER);
    } else {
      // 显示状态栏
      scbStatusBarStatusManager.showStatusBar(undefined, StatusBarType.TYPE_MAIN_PHONE_LAUNCHER);
      // 退出编辑模式，隐藏UIExtension
      setTimeout(() => {
        // 控制UIExtension下树比EditMode慢、否则会先看到一帧EditMode
        this.editModeExtensionData.setShowUIExtension(false);
        launcherVisualEffectMgr.setShowUIExtension(false);
      })
    }
  }

  /**
   * 是否正在下载中的应用
   * @param appInfo
   * @returns
   */
  public isDownloadingApp(appInfo: GridLayoutItemInfo): boolean {
    return appInfo.typeId === CommonConstants.TYPE_APP && appInfo.appStatus !== AppStatus.INSTALLED;
  }

  /**
   * 卸载APP
   *
   * @param appInfo 卸载元素信息
   * @returns boolean 是否满足卸载条件
   */
  public uninstallApp(appInfo?: GridLayoutItemInfo): boolean {
    if (appInfo && appInfo.bundleName) {
      let appItem: AppItemInfo = appInfo.toAppItemInfo();
      if (appInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_SHORTCUT_ITEM_DELETE, appItem);
        return true;
      }
      if (this.isDownloadingApp(appInfo)) {
        AppInstallUtils.getInstance().cancelTask(appInfo.bundleName);
        return true;
      }
      if (appInfo.typeId === CommonConstants.TYPE_APP && appInfo.isUninstallAble) {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_UNINSTALL_APPLICATION, appItem);
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_AUTO_ALIGN_AFTER_UNINSTALL, [appItem]);
        return true;
      }
    }
    return false;
  }

  /**
   * 通知白框显示隐藏
   *
   * @param isShow 是否显示白框
   */
  public notifyWhiteBoxShowOrHide(isShow: boolean): void {
    let currentPageIndex: number = desktopUtil.getPageIndexValue();
    if (SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()) {
      currentPageIndex = currentPageIndex + 1;
    }
    log.showInfo(`notify whiteBox in page: ${currentPageIndex} visibility change, isShow: ${isShow}`);
    GlobalContext.getContext()?.eventHub.emit(`${EditModeConstants.EVENT_EDIT_MODE_ENTER_HOT_AREA}${currentPageIndex}`,
      !isShow);
  }

  /**
   * 当进入热点时刷新拖拽对象颜色
   *
   * @param isEnterHotArea 是否进入热区
   * @param isDragCardItem 是否拖拽卡片
   */
  public refreshDragItemColor(isEnterHotArea: boolean, isDragCardItem?: boolean): void {
    if (isEnterHotArea) {
      dragController.getDragPreview()?.setForegroundColor(isDragCardItem ?
        EditModeStyleConstants.ENTER_HOT_AREA_CARD_BG_COLOR : EditModeStyleConstants.ENTER_HOT_AREA_APP_BG_COLOR);
    } else {
      dragController.getDragPreview()?.setForegroundColor(EditModeStyleConstants.LEAVE_HOT_AREA_BG_COLOR);
    }
  }

  /**
   * 在缓存中查找目标元素
   *
   * @param dragItemInfo 目标元素信息
   * @returns GridLayoutItemInfo
   */
  public findItem(dragItemInfo?: GridLayoutItemInfo): GridLayoutItemInfo | undefined {
    if (!dragItemInfo) {
      log.error('find item failed.');
      return undefined;
    }
    const appListInfo = AppStorage.get((desktopUtil.getAppListInfo())) as AppListInfo;
    let pageIndex: number = desktopUtil.getPageIndexValue();
    const isValidCache: boolean = appListInfo != null && appListInfo.appGridInfo != null;
    const isValidPageIndex: boolean = pageIndex >= 0 && pageIndex < appListInfo.appGridInfo.length;
    if (isValidCache && isValidPageIndex) {
      let dragInfo: GridLayoutItemInfo | undefined =
        appListInfo.appGridInfo[pageIndex].find(item => this.isSameItem(item, dragItemInfo));
      if (SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus() && !dragInfo &&
        pageIndex < appListInfo.appGridInfo.length - 1) {
        return appListInfo.appGridInfo[pageIndex + 1].find(item => this.isSameItem(item, dragItemInfo));
      } else {
        return dragInfo;
      }
    }
    log.info('no item found.');
    return undefined;
  }

  private isSameItem(currentItem: GridLayoutItemInfo | MoveItem,
    targetItem: GridLayoutItemInfo | MoveItem): boolean {
    if (!currentItem || currentItem.typeId !== targetItem?.typeId) {
      return false;
    }
    if (currentItem.typeId === CommonConstants.TYPE_APP && currentItem?.keyName === targetItem?.keyName) {
      return true;
    }
    if (currentItem.typeId === CommonConstants.TYPE_CARD && currentItem?.cardId === targetItem?.cardId) {
      return true;
    }
    return false;
  }

  private vibratorOfEnterEditMode(): void {
    log.showInfo('enter editMode vibrator');
    vibratorMgr.startVibration(EditModeConstants.VIBRATOR_TYPE_OF_ENTER_EDITMODE,
      CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
  }

  /**
   * 是否禁用上滑缩放动效（编辑模式dock应用拉起场景）
   *
   * @returns 是否禁用上滑缩放动效 true-禁用，false-不禁用
   */
  public isDisableFollowAnimateInEditMode(): boolean {
    return editModeManager.isInEditMode() && (
      FormCenterViewManager.getInstance().isFormCenterViewShowing() || this.editModeExtensionData.isShowUIExtension()
    )
  }

  /**
   * 是否为深色壁纸
   */
  public isDarkWallPaper(): boolean {
    editModeDockViewModel.updateFontColor();
    const res: boolean = editModeDockViewModel.isDarkWallpaper();
    log.showInfo(`isDarkWallPaper ${res}`);
    return res;
  }

  /**
   * 获取空白页参数
   *
   * @param isOuter 是否是外屏
   * @returns 获取空白页的参数
   */
  public getBlankPageViewParams(isOuter?: boolean): EditModeBlankPageViewParams {
    let blankPageViewParams: EditModeBlankPageViewParams = new EditModeBlankPageViewParams();
    if (isOuter) {
      blankPageViewParams.bgHeight = EditModeUtils.getOuterBackgroundSize();
      blankPageViewParams.bgWidth = EditModeUtils.getOuterBackgroundSize();
      blankPageViewParams.iconSize = OuterEditConstants.PAGE_EDIT_BUTTON_ICON_SIZE;
      blankPageViewParams.buttonSize = OuterEditConstants.PAGE_EDIT_BUTTON_SIZE;
      blankPageViewParams.buttonBorderRadius = blankPageViewParams.buttonSize / 2;
      blankPageViewParams.bgBorderRadius = OuterEditConstants.getBgBorderRadius();
    } else {
      blankPageViewParams.bgHeight = EditModePageStaticData.editModeBgHeight;
      blankPageViewParams.bgWidth = StyleConstants.PERCENTAGE_100;
      blankPageViewParams.iconSize = editModeManager.getEditModeStyleConfig().pageEditButtonIconSize;
      blankPageViewParams.buttonSize = editModeManager.getEditModeStyleConfig().pageEditButtonSize;
      blankPageViewParams.buttonBorderRadius = blankPageViewParams.buttonSize / 2;
      blankPageViewParams.bgBorderRadius =
        EditModeUtils.getBgBorderRadius(AppStorage.get<number>('screenWidth') as number);
    }
    return blankPageViewParams;
  }
}

/**
 * 桌面布局信息，二维数组，其中appGridInfo[i][j]表示第i页第j个元素
 */
export class AppListInfo {
  public appGridInfo: [GridLayoutItemInfo[]] = [[]];
}

/**
 * 编辑模式下添加页参数信息
 */
export class EditModeBlankPageViewParams {
  public bgHeight: number = 0;
  public bgWidth: number | string = 0;
  public iconSize: number = 0;
  public buttonSize: number = 0;
  public buttonBorderRadius: number = 0;
  public bgBorderRadius: number = 0;
};

export const editModeViewManager: EditModeViewManager = SingletonHelper.getInstance(EditModeViewManager, TAG);