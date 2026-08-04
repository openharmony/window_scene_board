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

import Prompt from '@ohos.promptAction';
import { LogDomain, LogHelper, SingletonHelper, Trace } from '@ohos/basicutils';
import {
  AccessibilityManager,
  GlobalContext,
  SCBDesktopCacheManager,
  SceneIdentificationManager,
  SceneState,
  sSettingsUtil,
  WallpaperColorManager
} from '@ohos/frameworkwrapper';
import { desktopUtil } from '@ohos/componenthelper';
import { launcherStatusUtil, ResUtils, SCBScreenSessionManager, SCBTransitionManager } from '@ohos/windowscene';
import { DropAnimationCancelReason, DropAnimationTsAdapter, } from '@ohos/componentanimator';
import { SettingsKeyConstants, SettingsConstants, WallpaperConstants } from '@ohos/commonconstants';
import { settings } from '@kit.BasicServicesKit';
import { AppStatus, CommonConstants, DesktopMode } from '../../constants/CommonConstants';
import { EventConstants } from '../../constants/EventConstants';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { EditModeState } from '../data/EditModeState';
import { EditModeFolderViewData } from '../data/EditModeFolderViewData';
import { EditModeReportManager } from '../hisysevent/EditModeReportManager';
import { EditModeViewState } from '../data/EditModeViewState';
import { ShowNameState } from '../data/ShowNameState';
import { EditModeWallpaperState } from '../data/EditModeWallpaperState';
import { EditModeViewData } from '../data/EditModeViewData';
import { EditModeStyleConfig } from '../data/PageEditData';
import { HiEditModeDataExitType } from '../hisysevent/HiEditModeData';
import { MultiSelectManager } from './MultiSelectManager';
import { FolderOperationFlag } from '../../folder/model/FolderData';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { LaunchLayoutCacheManager } from '../../cache/layout/LaunchLayoutCacheManager';
import { PageInfoManager } from '../../cache/layout/PageInfoManager';
import { ContactCacheManager } from '../../cache/layout/ContactCacheManager';
import GridLayoutUtil from '../../utils/GridLayoutUtil';
import { layoutLockUtil } from '../../utils/LayoutLockUtil';
import {
  EditModeUtils,
  FolderConstants,
  FolderManager,
  NavBarHideAndShowManager
} from '../../TsIndex';
import { EditModeAccessibilityUtil } from '../utils/EditModeAccessibilityUtil';
import { DesktopModeManager } from '../../desktopmode/statemanager/DesktopModeManager';
import { ContractedFolderCommonViewModel } from '../../folder/next/common/viewmodel/ContractedFolderCommonViewModel';
import { DesktopItemVibratorManager } from '../../manager/DesktopItemVibratorManager';

const TAG: string = 'EditModeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const CHANGE_DESKTOP_MODE_DELAY = 20;
/**
 * EditMode管理类
 */
export class EditModeManager {
  private desktopMode: DesktopMode = DesktopMode.NORMAL_MODE;
  private editModeReportManager: EditModeReportManager;
  private editModeState: EditModeState;
  private editModeViewState: EditModeViewState;
  private editModeFolderViewData: EditModeFolderViewData;
  private editModeWallpaperState: EditModeWallpaperState;
  private showNameState: ShowNameState;
  private isShowingUninstallDialog: boolean = false;
  private editModeViewData: EditModeViewData;
  private editModeStyleConfig: EditModeStyleConfig;
  private pickerLaunchStatus: boolean = false;
  private isSettingDataObserverRegistered: boolean = false;

  constructor() {
    this.editModeReportManager = new EditModeReportManager();
    this.editModeState = new EditModeState();
    this.editModeViewState = new EditModeViewState();
    this.editModeFolderViewData = new EditModeFolderViewData();
    this.editModeWallpaperState = new EditModeWallpaperState();
    this.showNameState = new ShowNameState();
    this.editModeViewData = new EditModeViewData();
    this.editModeStyleConfig = new EditModeStyleConfig();
  }

  public getPickerLaunchStatus(): boolean {
    return this.pickerLaunchStatus;
  }

  /**
   * 注册settingData监听器
   */
  private registerSettingDataObserver(): void {
    if (this.isSettingDataObserverRegistered) {
      log.showError('AppLaunching is registered');
      return;
    }
    try {
      // 注册监听
      this.isSettingDataObserverRegistered = settings.registerKeyObserver(
        GlobalContext.getContext(),
        SettingsKeyConstants.SCREENLOCK_ARTSIGN_AIGC_STATUS,
        settings.domainName.USER_SECURITY,
        async () => {
          this.onEditModePickerStatusChange();
        }
      );
    } catch (err) {
      log.showError(`registerSettingDataObserver error: ${err.getMessage()}`);
    }
  }

  /**
   * 壁纸编辑半模态picker页状态变化
   */
  private onEditModePickerStatusChange(): void {
    sSettingsUtil.getSecureValueAsync(SettingsKeyConstants.SCREENLOCK_ARTSIGN_AIGC_STATUS)
      .then((v) => {
        log.showInfo(`${SettingsKeyConstants.SCREENLOCK_ARTSIGN_AIGC_STATUS} change, new value: ${v}`);
        this.pickerLaunchStatus = v === SettingsConstants.TRUE_STRING;
      })
      .catch((err: Error) => {
        log.showError(`watch ${SettingsKeyConstants.SCREENLOCK_ARTSIGN_AIGC_STATUS} error, ${err?.message}`);
      });
  }

  /**
   * 获取编辑模式Data
   *
   * @returns EditModeViewData
   */
  public getEditModeViewData(): EditModeViewData {
    if (!this.editModeViewData) {
      this.editModeViewData = new EditModeViewData();
    }
    return this.editModeViewData;
  }

  /**
   * 获取编辑模式样式配置
   *
   * @returns EditModeStyleConfig
   */
  public getEditModeStyleConfig(): EditModeStyleConfig {
    if (!this.editModeStyleConfig) {
      this.editModeStyleConfig = new EditModeStyleConfig();
    }
    return this.editModeStyleConfig;
  }

  /**
   * 初始化是否显示名称
   */
  public initIsShowAppName(): void {
    sSettingsUtil.getSecureValueAsync('isDesktopIconShowName').then((v) => {
      this.showNameState.setIsShowName(v !== 'false');
    }).catch((err: Error) => {
      log.showError(`initIsShowAppName error, ${err?.message}`);
    });
  }

  /**
   * 切换编辑模式总入口
   *
   * @param mode 桌面模式
   * @param type 切换场景
   */
  public async changeDesktopMode(mode: DesktopMode, type?: number): Promise<void> {
    if (this.desktopMode === mode) {
      log.showInfo('mode has not changed');
      return;
    }
    log.showInfo(`changeDesktopMode>>> mode: ${mode}, type: ${type}, pickerLaunchStatus: ${this.pickerLaunchStatus}`);
    if (mode === DesktopMode.EDIT_MODE) {
      this.registerSettingDataObserver();
    } else if (mode === DesktopMode.NORMAL_MODE && this.pickerLaunchStatus) {
      if (type === HiEditModeDataExitType.EXIT_FULLY_OCCLUSION) {
        // 编辑模式设置壁纸拉起图库picker页后，启动应用不退出编辑模式
        log.showInfo('editMode launching photo picker');
        return;
      } else {
        sSettingsUtil.setSecureValue(SettingsKeyConstants.SCREENLOCK_ARTSIGN_AIGC_STATUS,
          SettingsConstants.FALSE_STRING, GlobalContext.getContext());
      }
    }
    this.desktopMode = mode;
    AppStorage.setOrCreate('isNormalDesktopMode', this.isInNormalMode());
    this.cancelOtherAnimate();
    let desktopContext: ServiceExtensionContext = GlobalContext.getContext();
    // 先通知和布局相关事件
    desktopContext?.eventHub.emit(EventConstants.EVENT_CHANGE_DESKTOP_MODE_LAYOUT);
    // 先通知动画执行、让编辑模式动画先跑起来、否则动画时延会不达标
    desktopContext?.eventHub.emit(EventConstants.EVENT_CHANGE_DESKTOP_MODE_ANIMATE, mode === DesktopMode.EDIT_MODE);

    // 分批通知桌面元素刷新，避免同一时间送显过多导致动效卡顿，当前优先顺序为动效开启->布局刷新->多选框上树->名称阴影隐藏
    await EditModeUtils.sleep(CHANGE_DESKTOP_MODE_DELAY);
    this.editModeState.setIsInEditMode(this.isInEditMode());
    const isAccessibilityMode = AppStorage.get<boolean>('isAccessibilityMode') as boolean || false;
    const accessibilityManager = AccessibilityManager.getInstance();
    this.setEnableScreenRotate();
    this.notifyIdentificationState();
    const pageIndex: number = desktopUtil.getPageIndexValue();
    const accessString: string = '，' + EditModeAccessibilityUtil.getAccessibilityText(pageIndex);

    SCBDesktopCacheManager.getInstance().resetFreezeStateOnly('EDIT_MODE_CHANGE');
    if (this.isInEditMode()) {
      Trace.start(Trace.CORE_METHOD_INTO_EDIT_MODE);
      this.editModeReportManager.reportEnterEditMode(type);
      if (isAccessibilityMode) {
        accessibilityManager.sendTextAnnouncedForAccessibility(
          ResUtils.getInnerString($r('app.string.enter_edit_mode')) + accessString,
          'textAnnouncedForEnterEditMode');
      }
      DesktopItemVibratorManager.getInstance().setEffectId(CommonConstants.VIBRATION_EFFECT_LIGHT, 'enterEditMode');
    } else {
      // 显示NAVIBar
      NavBarHideAndShowManager.getInstance().executeCallbackByType(TAG, true);
      this.editModeReportManager.reportLeaveEditMode(type);
      Trace.end(Trace.CORE_METHOD_INTO_EDIT_MODE);
      if (isAccessibilityMode) {
        accessibilityManager.sendTextAnnouncedForAccessibility(
          ResUtils.getInnerString($r('app.string.exit_edit_mode')) + accessString,
          'textAnnouncedForExitEditMode');
      }
      DesktopItemVibratorManager.getInstance().resetEffectId();
    }
    desktopContext?.eventHub.emit(EventConstants.EVENT_CHANGE_DESKTOP_MODE);

    await EditModeUtils.sleep(CHANGE_DESKTOP_MODE_DELAY);
    if (this.isInEditMode()) {
      MultiSelectManager.getInstance().load();
    } else {
      MultiSelectManager.getInstance().unload();
    }

    await EditModeUtils.sleep(CHANGE_DESKTOP_MODE_DELAY);
    desktopContext?.eventHub.emit(EventConstants.EVENT_CHANGE_DESKTOP_MODE_NAME);
  }

  private setEnableScreenRotate(): void {
    try {
      const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
      log.info(`setEnableSensorRotate ${!this.isInEditMode()}`);
      // 编辑模式中 禁用屏幕旋转，退出编辑模式，取消禁用
      screenSession?.setEnableRotate(!this.isInEditMode(), TAG);
    } catch (error) {
      log.showError(`setEnableSensorRotate failed: ${error?.message}`);
    }
  }

  private cancelOtherAnimate(): void {
    try {
      DropAnimationTsAdapter.cancelDropAnimation(DropAnimationCancelReason.EDIT_MODE_CHANGE);
      ContractedFolderCommonViewModel.getInstance()
        .closeFolder('close folder by edit mode change', FolderOperationFlag.IMMEDIATELY);
      if (this.isInEditMode()) {
        SCBTransitionManager.getInstance().cancelCloseAppAnimate();
      }
    } catch (error) {
      log.showError(`cancelOtherAnimate failed: ${error?.message}`);
    }
  }
  
  /**
   * 获取桌面模式
   *
   * @returns DesktopMode
   */
  public getDesktopMode(): DesktopMode {
    return this.desktopMode;
  }

  /**
   * 获取ShowNameState
   *
   * @returns ShowNameState
   */
  public getShowNameState(): ShowNameState {
    return this.showNameState;
  }

  /**
   * 获取编辑模式状态对象
   *
   * @returns EditModeState
   */
  public getEditModeState(): EditModeState {
    return this.editModeState;
  }

  /**
   * 获取编辑模式UI状态对象
   *
   * @returns EditModeViewState
   */
  public getEditModeViewState(): EditModeViewState {
    return this.editModeViewState;
  }

  /**
   * 获取编辑模式Folder视图状态对象
   *
   * @returns EditModeFolderViewData
   */
  public getEditModeFolderViewData(): EditModeFolderViewData {
    return this.editModeFolderViewData;
  }

  /**
   * 获取编辑模式壁纸视图状态对象
   *
   * @returns EditModeWallpaperState
   */
  public getEditModeWallpaperState(): EditModeWallpaperState {
    return this.editModeWallpaperState;
  }

  /**
   * 是否处于编辑模式
   *
   * @returns boolean
   */
  public isInEditMode(): boolean {
    return this.desktopMode === DesktopMode.EDIT_MODE;
  }

  /**
   * 点击空白区域退出编辑模式
   */
  public clickBlankSpace(): void {
    let isDrag: boolean = AppStorage.get<boolean>('isDrag') as boolean;
    let isMultiSelect: boolean = MultiSelectManager.getInstance().inAnimation ?? false;
    log.showInfo(`isDrag: ${isDrag} isMultiSelect ${isMultiSelect}`);
    if (!isDrag && !isMultiSelect && this.isInEditMode()) {
      log.showDebug('exit edit mode.');
      editModeManager.changeDesktopMode(DesktopMode.NORMAL_MODE, HiEditModeDataExitType.EXIT_BLANK_CLICKED);
    }
  }

  /**
   * 是否处于正常模式
   *
   * @returns boolean
   */
  public isInNormalMode(): boolean {
    return this.desktopMode === DesktopMode.NORMAL_MODE;
  }

  /**
   * 删除弹框是否展示
   *
   * @returns boolean
   */
  public setIsShowingUninstallDialog(isShow: boolean): void {
    this.isShowingUninstallDialog = isShow;
  }

  /**
   * 删除弹框是否展示
   *
   * @returns boolean
   */
  public getIsShowingUninstallDialog(): boolean {
    return this.isShowingUninstallDialog;
  }

  /**
   * 是否展示设置主屏按钮
   *
   * @param isInEditMode 当前是否编辑模式，必传，否则UI不刷新
   * @param index 当前页下标
   * @returns 是否
   */
  public isShowHomePageButton(isInEditMode: boolean, index: number): boolean {
    return isInEditMode && PageInfoManager.getInstance().isHomePageSetSupport() &&
      (PageInfoManager.getInstance().getDisplayCount() === 1 ||
        index % PageInfoManager.getInstance().getDisplayCount() === 1)
  }

  /**
   * 判断编辑模式下的元素是否可拖拽
   *
   * @param item 桌面元素信息
   * @returns 是否可拖拽
   */
  public isDraggable(item: GridLayoutItemInfo): boolean {
    if (this.isInNormalMode()) {
      return true;
    }
    let cached: GridLayoutItemInfo | undefined = LaunchLayoutCacheManager.getInstance()
      .selectGridLayoutItemByItem(item);
    if (!cached) {
      log.showWarn(`drag item not in desktop cache. key:${GridLayoutUtil.generateUniqueKey(item)}`);
      return true;
    }
    let page: number = AppStorage.get<number>(desktopUtil.getPageIndex()) ?? -1;
    let currentDisplayCount = PageInfoManager.getInstance().getDisplayCount();
    const currentShowingPages = EditModeUtils.getCurrentShowingPage(page, currentDisplayCount);
    if (currentShowingPages.indexOf(cached.page ?? -1) !== -1) {
      return true;
    }
    log.showWarn(`cannot drag form not in current page. key:${GridLayoutUtil.generateUniqueKey(item)}` +
      ` page:${cached.page} pageIndex:${page}`);
    return false;
  }

  public canDeleteIconShow(item: GridLayoutItemInfo): boolean {
    if (!this.isInEditMode()) {
      return false;
    }
    if (ContactCacheManager.getInstance().isContactShortcut(item)) {
      return false;
    }
    if (!editModeManager.isDraggable(item)) {
      return false;
    }
    const folderMgr: FolderManager = FolderManager.getInstance();
    const isOpenFolder: boolean = folderMgr.isFolderOpen();
    const curPage: number = isOpenFolder ? folderMgr.getOpenedFolder().page : item.page;
    if (layoutLockUtil.isLockedPage(curPage, 'show deleteIcon by longPress', true)) {
      return false;
    }
    if (item.typeId === CommonConstants.TYPE_APP && item.appStatus === AppStatus.INSTALLED && !item.isUninstallAble &&
      !launcherStatusUtil.getShowOutLauncherStatus()) {
      return false;
    }
    return true;
  }

  /**
   * 获取文件夹额外背板的亮度，在极浅壁纸时，压暗5%以使其更加明显
   */
  public getFolderExtraBackgroundLight(): number {
    const textColor = WallpaperColorManager.getInstance().mTextColor;
    if (textColor == null || textColor.mWallpaperType == null) {
      log.showError('textColor params error');
      return FolderConstants.FOLDER_EXTRA_BACKGROUND_DEFAULT_LIGHT;
    }
    const isWhiteWallPaper = textColor.mWallpaperType === WallpaperConstants.WALLPAPER_TYPE_ONE;
    return isWhiteWallPaper ? FolderConstants.FOLDER_EXTRA_BACKGROUND_LIGHT_UNDER_WHITE_WALL_PAPER :
      FolderConstants.FOLDER_EXTRA_BACKGROUND_DEFAULT_LIGHT;
  }

  /**
   * 进入退出编辑模式通知悬浮窗
   *
   * EDIT_MODE_ENTER 进入编辑模式 ，EDIT_MODE_EXIT 退出编辑模式
   */
  private notifyIdentificationState(): void {
    try {
      if (this.isInEditMode()) {
        SceneIdentificationManager.notify(SceneState.EDIT_MODE_ENTER);
      }
      if (this.isInNormalMode()) {
        SceneIdentificationManager.notify(SceneState.EDIT_MODE_EXIT);
      }
    } catch (error) {
      log.showError(`notifyIdentificationState err: ${error?.message}`);
    }
  }

  /**
   * 锁定布局弹出toast框
   */
  public toastLockedLayout(): void {
    if (DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode()) {
      log.showWarn('isInEmergencyOrThermalSafeMode');
      return;
    }
    log.showWarn(`layout is locked, show Toast`);
    try {
      Prompt.showToast({
        message: $r('app.string.desktop_layout_locked'),
        duration: 1000,
        showMode: Prompt.ToastShowMode.SYSTEM_TOP_MOST,
      });
    } catch (error) {
      log.showError(`showToast args error code is ${error.code}, message is ${error.message}`);
    }
  }

  /**
   * (演示模式-恢复布局)设置是否显示app名称
   *
   * @throws { Error } update icon show name failed!
   * @param isNameShow 是否显示app名称
   */
  public updateShowAppName(isNameShow: boolean): void {
    if (this.showNameState.isShowName() === isNameShow) {
      return;
    }
    this.showNameState.setIsShowName(isNameShow);
    let res: boolean = sSettingsUtil.setSecureValue('isDesktopIconShowName', isNameShow.toString());
    if (!res) {
      throw new Error('update icon show name failed!');
    }
  }
}

export const editModeManager: EditModeManager = SingletonHelper.getInstance(EditModeManager, TAG);