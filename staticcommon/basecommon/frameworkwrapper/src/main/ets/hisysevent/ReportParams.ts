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

import type { OneStepSplitType, SplitType } from '@ohos/commonconstants';
import { bundleManager } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { HiSysDockEditType, HiSysLongPressMisTouchType } from './HiSysData';
import { DeviceHelper } from '../base/DeviceHelper';

const TAG = 'ReportParams';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

// 设备状态枚举
export enum DisPlayMode {
  BAR_DEVICE,
  FOLD_DEVICE_EXPAND,
  FOLD_DEVICE_UNEXPAND,
  ULTRA_SCREEN_DEVICE_F,
  ULTRA_SCREEN_DEVICE_M,
  ULTRA_SCREEN_DEVICE_G
}

export enum WindowStateChangeMode {
  ENTER,
  EXIT,
  SWITCH,
}

export enum MultiWindowMode {
  FLOATING = 1,
  SPLIT_PRIMARY = 2,
  SPLIT_SECONDARY = 3,
  MIDDLE_SCENE = 4,
}

export enum MultiWindowContainerMode {
  SPLIT = 0,
  MID_SCENE = 1,
}

export enum BatchEnterSplitOrMidSceneReason {
  DEFAULT = 0,
  COMBINATION = 1,
  SCENE_LINKAGE = 2,
  CLICK_CAPSULE = 3,
}

export enum ScreenOrientation {
  PORTRAIT,
  LANDSCAPE,
}

export enum ReplaceReason {
  NOTIFICATION,
  APPLICATIONINSIDE,
  SIDEEDGEBAR,
  DOCK_CLICK,
  DOCK_DRAG,
  APP_MULTI_WINDOW,
}

export enum StartSplitReason {
  APP_MULTI_WINDOW,
  DEFAULT,
}

// 是否是中景窗枚举
export enum MidSceneState {
  IS_NOT_MID_SCENE,
  IS_MID_SCENE,
}

export class ReportParams {
  private static versionCode: number;
  public static PACKAGE_NAME: string = 'com.ohos.sceneboard';
  public static PROCESS_NAME: string = 'sceneBoard';
  public static PARTITION_NAME: string = '/data/storage/el1~5';

  public static async getVersionCode(): Promise<string> {
    if (!ReportParams.versionCode) {
      let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT;
      try {
        const bundleInfo = await bundleManager.getBundleInfoForSelf(bundleFlags);
        // 获取应用的版本名（versionCode）
        ReportParams.versionCode = bundleInfo?.versionCode;
      } catch (err) {
        log.error('getVersionCode failed:', err);
      }
    }
    return `${ReportParams.versionCode || ''}`;
  }
}

export class FoldParams {
  public static FOLD_DEVICE_TYPE: number | undefined =
    DeviceHelper.isPhone() ? DeviceHelper.getFoldProductType() : undefined;

  /**
   * @param expandStatus: 用于替换 SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()，从上层传入，解除反向依赖
   * @returns
   */
  public static getDisplayType(expandStatus: boolean): boolean | undefined {
    if (this.FOLD_DEVICE_TYPE > 0) {
      return expandStatus;
    } else {
      return undefined;
    }
  }
}

export class GetFlashLightStatusParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  STATUS?: string;
}

export class DefaultParams {
  PACKAGE_NAME: string = ReportParams.PACKAGE_NAME;
  PROCESS_NAME: string = ReportParams.PROCESS_NAME;
}

export class WritePreloadLayoutParams extends DefaultParams {
  MESSAGE: string;
}

export class HibernateDialogParams extends DefaultParams {
  VALUE?: string;
}

export class CommParams extends DefaultParams {
  PROGRESS?: number;
  TYPE?: number;
  STREAM?: number;
}

export class SystemMenuClickParams extends DefaultParams {
  NAME?: number;
  EVENT_TYPE?: string;
}

export class SoundParams extends SystemMenuClickParams {
  VOLUME: number | undefined | null;
}

export class InputParams extends DefaultParams {
  NAME?: number;
  INPUT_METHOD?: string;
  LANGUAGE?: string;
}

export class NotificationParams extends DefaultParams {
  STATUS?: number;
}

export class WakeScreenParams extends DefaultParams {
  SWITCH_STATUS?: number;
}

export class ManageAllParams extends DefaultParams {
  STATE?: number;
  SHOT_TYPE?: number;
  COMMAND?: number;
}

export class InManageAllParams extends DefaultParams {
  BUNDLE_NAME?: string;
  SWITCH_STATUS?: number;
}

export class ApplicationParams extends DefaultParams {
  BUNDLE_NAME?: string;
  STATE?: number;
}

export class ClickParams extends DefaultParams {
  TOGGLE_NAME?: string;
  CLICK_TYPE?: number;
}

export class ToggleParams extends DefaultParams {
  TOGGLE_DATA?: string;
}

export class SwipeSwitchParams extends DefaultParams {
  TARGET?: number;
  RESULT?: string;
  STARTX?: number;
  STARTY?: number;
  ENDX?: number;
  ENDY?: number;
}

export class DeleteParams extends DefaultParams {
  PKG?: string;
  DIRECTION?: number;
  EXPAND?: boolean;
}

export class DeleteNtfOverLimitParams extends DeleteParams {
  ID?: number;
  TAG?: string;
  BUTTON_NAME?: string;
}

export class ItemClickParams extends DeleteParams {
  STATE?: number;
}

export class QuickToggleRingModeParams extends DefaultParams {
  NEWSTATE?: number;
}

export class ExpandVolPanelParams extends DefaultParams {
  EXPAND?: 0 | 1;
  PKG?: string;
  ID?: number;
}

export class NtfSetPinTopParams extends DefaultParams {
  OPERATIONTYPE?: string;
  PKG?: string;
  SILENCE?: number;
}

export class AppCategoryParams {
  BUNDLE_NAME?: string;
  SECONDARY_CATEGORY_ID?: number;
  ERROR_CODE?: number;
}

export class LogoLParams {
  TIMES?: number;
  isDown?: boolean;
  CURRENT_TIME?: string;
  DOWN_OR_UP?: 0 | 1;
}

export class PluginFailedParams {
  BUNDLENAME?: string;
  EVENT_TYPE?: number;
  FAULT_MSG?: string;
}

export class IconClickParams {
  BUNDLENAME?: string;
  TIMES?: number;
  CURRENT_TIME?: string;
}

export class ButtonEventParams extends DefaultParams {
  NAME?: string;
  BUNDLE_NAMES?: string;
  SHORTCUT_NAME?: string;
}

export class KeyboardStateParams {
  TYPE?: number;
}

export class MultiWindowStateParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE?: number;
  MULTI_NUM?: number;
  MULTI_WINDOW?: string;
  DISPLAY_ORI?: number;
  WINDOW_STATE?: number;
}

export class DockRegionTypeItemsCountParams {
  DOCKREGIONTYPE: string;
  ITEMSCOUNT: number;
  EVENTTYPE: string;
}

export class ScreenUnlockEventParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  VERIFYSUCESS?: boolean;
  VERIFY_COSTTIME?: number;
  E2E_LATENCY?: number;
  TYPE?: string;
  FACIALMETHOD?: number;
  SCREENSTATE?: string;
  PWDUI?: string;
  SWITCHMODE?: string;
}

export class SwitchViewParams extends DefaultParams {
  BOX_VIEW_TYPE?: number;
  OPERATE_TYPE?: number;
  UDID?: string;
  BOX_ID?: string;
  BOX_SORT_TYPE?: number;
  EVENT_TYPE?: number;
  DESKTOP_MENU_ITEM?: string;
  DESKTOP_MENU_STATE?: number;
}

export class RotationEndParams {
  ROTATION_START_TIME?: string;
  SCREEN_ID?: number;
  SCENE_PANEL_NAME?: string;
  ROTATION_DURATION?: number;
}

export class UnlockToDesktopParams extends DefaultParams {
  PAGE_INDEX?: number;
}

export class ReturnToHomeKeyParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  INDEX?: number;
  SCREEN_TYPE?: number;
}

export class SlGreetModeParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  SCENE?: string;
}

export class SlResetPinParams {
  PNAMEID: string;
  PVERSIONID: string;
  SCENE: string;
}

// 上滑清屏用户行为事件打点参数
export class ShowDesktopGestureParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  IS_SHOW?: boolean;
}

// 三指下滑还原用户行为事件打点参数
export class RestoreDesktopGestureParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  IS_RESTORE?: boolean;
  IS_EXIT_RECENT?: boolean;
}

//2x4大文件夹弹窗成功打点参数
export class FolderNaviParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  CHECK_COUNT?: number;
}

//2x4大文件夹未成功弹窗打点参数
export class FolderNaviNoTrigParams {
  CHECK_COUNT?: number;
}

// 文件夹数量
export class FolderNumsParams {
  FOLDER_NUM: number;
}

// item数量
export class ItemNumsParams {
  ITEM_NUM: number;
}

// 切换主题时间
export class ChangeThemeParams {
  USE_TIME: number;
}

// 桌面加載时间
export class LoadedDesktopParams{
  USE_TIME: number;
}

// 切换主题时，有滑动或者启动应用
export class ChangeThemeSlideOrStartParams{
  SLIDE_ACTION: boolean;
  START_ACTION: boolean;
}

// 上滑停顿进多任务用户行为事件打点参数
export class ToRecentGestureParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  IS_TO_RECENT?: boolean;
}

export class SwitchingType {
  SWITCHING_TYPE?: string;
  CURRENT_TIME?: number;
}

export class SwitchEnterpriseMultiSpaceParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  CURRENT_SPACE?: number;
  TARGET_SPACE?: number;
  SWITCH_TYPE?: string;
  SWITCH_RESULT?: number;
}

export class GetSnapshotFailed {
  ERROR_INFO?: string;
  CURRENT_TIME?: number;
}

export class SwitchToPasswordParams {
  COSTTIME?: number;
  PASSWORDTYPE?: string;
  SWITCH_TO_USER?: number;
}

export class ReturnToHomeParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  FROM?: string;
  START_POS?: number[];
  END_POS?: number[];
  DEVICE_STATUS?: number;
  ORIENTATION?: number;
  CUR_BUNDLE_NAME?: string;
  SCREEN_TYPE?: number;
  IS_MIDSCENE?: number;
  INTELLIGENT_SCENE_MODE_ID?: string;
}

export class GoIntoRecentParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  FROM?: string;
  START_POS?: number[];
  END_POS?: number[];
  DEVICE_STATUS?: number;
  ORIENTATION?: number;
  CUR_BUNDLE_NAME?: string;
  SESSION_NUMBER?: number;
  SCREEN_TYPE?: number;
  IS_MIDSCENE?: number;
}

export class SceneBoardFileSizeParams {
  COMPONENT_NAME: string;
  PARTITION_NAME: string;
  REMAIN_PARTITION_SIZE: number;
  FILE_OR_FOLDER_PATH: string[];
  FILE_OR_FOLDER_SIZE: number[];
}

export class IntoOrExitAppCenterParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  SUCCESS?: string;
}

export class SlideLockAppInRecentParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
  LOCK_TYPE?: number;
}

export class ClearSingleAppInRecentParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
  UNCLEARABLE?: boolean;
  SCREEN_TYPE?: number;
}

export class ClearAllAppInRecentParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  SCREEN_TYPE?: number;
}

export class ClearAllAppInSCBRecentParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  UNCLEARABLELIST?: string[];
  SCREEN_TYPE?: number;
}

export class AodParams {
  pNameId?: string;
  pVersionId?: string;
  switchStatus?: number;
  displayMode?: number;
  displayTime?: string;
  foldStatus?: number;
}

export class SetAodParams extends AodParams {
  foldScreen?: number;
}

export class StartAodParams extends AodParams {
  style?: number;
  isFingerprintEnabled?: boolean;
  isImmersive?: boolean;
}

export class StopAodParams {
  pNameId?: string;
  pVersionId?: string;
  switchStatus?: number;
  displayMode?: number;
  aodTheme?: number;
  presetStyle?: number;
  styleName?: string;
  foldStatus?: number;
  rotationMode?: number;
}

export class EditAodParams {
  pNameId?: string;
  pVersionId?: string;
  sceneType?: string;
}

export class ApplyAodParams {
  pNameId?: string;
  pVersionId?: string;
  styleName?: string;
  isNotificationVisible?: boolean;
}

export class UpdateAodParams {
  pNameId?: string;
  pVersionId?: string;
  updateReason?: string;
  style?: number;
  isImmersive?: boolean;
}

export class DefaultAodParams {
  pNameId?: string;
  pVersionId?: string;
}

export class GoIntoAppInRecentParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
  SCREEN_TYPE?: number;
}

export class SnapToPageParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  ISSUCCESS?: boolean;
  ROTATIONMODE?: number;
  DEVICETYPE?: number;
  FROMPAGE?: number;
  TOPAGE?: number;
  SCREEN_TYPE?: number;
}

export enum ResultType {
  SUCCESS = 1,
  FAILED,
  // 撤消
  UNDO,
}

export enum AppCatErrorCode {
  // 分类信息查询成功
  SUCCESS = 0,
  // 分类信息查询失败
  QUERY_ERROR = -1,
  // 分类信息不存在
  NOT_EXIST = -2,
  // 本地国际化分类名称不存在
  CATEGORY_NAME_ERROR = -3,
}

export class CloseFolderParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  ISCARDFOLDER?: boolean;
  FOLDERPOSITIONINDESKTOP?: string;
  FOLDERCONTENT?: string;
  ISHIFOLDER?: boolean;
  FOLDERID?: string;
  FOLDERTYPE?: number;
}

export class DragFolderParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  ISCARDFOLDER?: boolean;
  DRAGSTARTPOSITIONINDESKTOP?: string;
  DRAGENDPOSITIONINDESKTOP?: string;
  FOLDERCONTENT?: string;
  ISHIFOLDER?: boolean;
  FOLDERID?: string;
  FOLDERTYPE?: number;
}

export class DissolveFolderParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  ISCARDFOLDER?: boolean;
  SHORTCUTCOUNT?: number;
  DISMISSREASON?: string;
  ISHIFOLDER?: boolean;
  FOLDERID?: string;
}

export class GoIntoAppShortcutMenuParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  COMPONENT?: string;
  TITLE?: string;
  SCENE?: string;
}

export class CreateBigFolderParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  FOLDERID?: string;
  SCREENTYPE?: number;
  TYPE?: boolean;
}
export class DeleteShortcutParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  BUNDLENAME?: string;
  SHORTCUTNAME?: string;
  //屏幕类型，1为其他屏（默认值），2为新形态小外屏
  SCREEN_TYPE?: number;
}

export class CreateSmallFolderParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  SCREENTYPE?: number;
  OPERATION?: number;
  FOLDERCONTENT?: string;
  FOLDERPOSITION?: string;
  FOLDERID?: string;
  APPCATEGORY?: string;
}

export class SnapToPageInFolderParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  FOLDERID?: string;
  APPCOUNT?: number;
  PAGECOUNT?: number;
  ISCARDFOLDER?: boolean;
  FOLDERTYPE?: number;
}

export class ReverseAddInFolderParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  FOLDERID?: string;
  FOLDERTYPE?: number;
  ISCARDFOLDER?: boolean;
}

export class DragIconIntoFolderParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  ISBATCH?: boolean;
  ISDRAGIN?: boolean;
  DRAGGINGPACKAGENAMES?: string;
  ISCARDFOLDER?: boolean;
  FOLDERPOSITIONINDESKTOP?: string;
  FOLDERCONTENT?: string;
  ISHIFOLDER?: boolean;
  FOLDERID?: string;
}

export class DragIconFromNotHarmonyFolderParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  ISCARDFOLDER?: boolean;
  FOLDERPOSITIONINDESKTOP?: string;
  FOLDERCONTENT?: string;
  FOLDERID?: string;
  FOLDERTYPE?: number;
}

export class DragIconIntoNotHarmonyFolderParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  ISCARDFOLDER?: boolean;
  FOLDERPOSITIONINDESKTOP?: string;
  FOLDERCONTENT?: string;
  FOLDERID?: string;
  FOLDERTYPE?: number;
}

export class LightIconInNotHarmonyFolderParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  BUNDLENAME?: string;
}

export class LightIconInNotHarmonyFolderBean {
  bundleName?: string;
}

export class RecentSwiperParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DIRECTION?: string;
}

export class DragChangeFolderSizeParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  OLDSPAN?: string;
  NEWSPAN?: string;
  OLDPOSITION?: string;
  NEWPOSITION?: string;
  PAGEINDEX?: string;
  FOLDERID?: string;
  ISHIFOLDER?: string;
  ISEDITMODE?: string;
  FOLDERTYPE?: number;
}

export class DragChangeFolderSizeFailParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  FAILEDTYPE?: number;
}

export class ClickAppInDockParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  CIID?: string;
}

export class ClickAppInShortcutParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  BUNDLE_NAME?: string;
}

export class ClickAppInDockRecentParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  BUNDLE_NAME?: string;
}

export class AdjustDockSplitLineParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  RECENT_APP_NUM_BEFORE_ADJUST?: number;
  RECENT_APP_NUM_AFTER_ADJUST?: number;
}

export class DeleteRecentAppParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  BUNDLE_NAME?: string;
}

export class DockRecentMenuParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  BUNDLE_NAME?: string;
  OPERATION_NAME?: string;
}

export class PauseAppDownload {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
}

export class ContinueAppDownload {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
}

export class AnimationDurationAppDownload {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
  VISIBLETIMEMS?: number;
}

export class CancelAppUninstall {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
  FOLDERTYPE?: number;
}

export class ReloadDesktop {
  PNAMEID?: string;
  PVERSIONID?: string;
  TIME?: number;
  USERID?: number;
  SCREEN_TYPE?: number;
}

export class DesktopInformation {
  PNAMEID?: string;
  PVERSIONID?: string;
  SCREEN?: number;
  ICON?: number;
  FA?: number;
  FORMSTACK?: number;
  FAOFFORMSTACK?: number;
  HOME_PAGE_INDEX?: number;
  BIGFOLDER?: number;
  SMALLFOLDER?: number;
  FOLDER?: number;
  PRESETS_STACK_NUM?: number;
  PRESETS_CARD_NUM?: number;
  UPGRADE_CARD_NUM?: number;
  CLICKBACKSTATUS?: boolean;
  ICONSIZE?: number;
  IS_NAME_SHOW?: boolean;
  THREE_BTN_POSITION_STYLE_WEEK?: string;
  FLOATING_BALL_SWITCH_STATUS?: string;
  LOCKLAYOUTSTATUS?: boolean;
  SHORTCUTICONNUMBER: number;
  BAREICONNUMBER: number;
  BARESHORTCUTICONNUMBER: number;
  DESKTOPLAYOUT: string;
  AUTOALIGNSTATUS: boolean;
}

export class OuterDesktopInformation {
  PNAMEID?: string;
  PVERSIONID?: string;
  ICON?: number;
  FA?: number;
  SCREEN?: number;
  FORMSTACK?: number;
  PRESETS_CARD_NUM?: number;
  PRESETS_STACK_NUM?: number;
  SHORTCUT_NUM?: number;
}

export class ClickAppIconParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  COMPONENT?: string;
  CONTAINERTYPE?: string;
  ICONPOSITIONINDESKTOP?: string;
  FOLDERPOSITIONINDESKTOP?: string;
  ICONPOSITIONINFOLDER?: string;
  ISBIGICONINCARDFOLDER?: string;
  ISHIFOLDER?: string;
  FOLDERID?: string;
  SCREEN_TYPE?: number;
  CLICKAPPTYPE?: number;
  APP_INDEX?: number;
  ISLIGHTING?: string;
  LIGHTINGTIME?: string;
}

export class ClickAppIconInstallBean {
  bundleName?: string;
  dTime?: string;
}

export class ClickAppIconInstallParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  BUNDLENAME?: string;
  DTIME?: string;
}

export class ClickShortcutParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  COMPONENT?: string;
  SHORTCUTID?: string;
  CONTAINERTYPE?: string;
  ICONPOSITIONINDESKTOP?: string;
  FOLDERPOSITIONINDESKTOP?: string;
  ICONPOSITIONINFOLDER?: string;
  FOLDERID?: string;
  SCREEN_TYPE?: number;
}

export class OpenFolderParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PAGENUM?: number;
  ICONNUM?: number;
  ISCARDFOLDER?: boolean;
  FOLDERPOSITION?: string;
  SHORTCUTCOUNT?: number;
  ISHIFOLDER?: boolean;
  FOLDERID?: string;
  FOLDERTYPE?: number;
}

export class LongPressFolderParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  ISCARDFOLDER?: boolean;
  ISHIFOLDER?: boolean;
  FOLDERID?: string;
}

export class LongPressAppClickShare {
  PNAMEID?: string;
  PVERSIONID?: string;
  BUNDLE_NAME?: string;
}

export class InAppAddShortcutToDesktop {
  PNAMEID?: string;
  PVERSIONID?: string;
  BUNDLE_NAME?: string;
  SHORTCUT_ID?: string;
}

export class RenameFolderParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  ISCARDFOLDER?: boolean;
  ISHIFOLDER?: boolean;
  FOLDERID?: string;
  ENTRANCE?: string;
  ISCHANGED?: boolean;
}

export class RenameNotHarmonyFolderParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  FOLDERTYPE?: number;
}

export class OpenUninstallAppDialogParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
  FOLDERTYPE?: number;
  ISCARDFOLDER?: boolean;
}

export class FolderOpenDeleteAppDialogParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
  ISHARMONYFOLDER?: string;
}

export class OpenDeleteAppDialogParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
}

export class ClickDeleteAppDialogParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
  FOLDERTYPE?: number;
}

export class RemoveAppParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
  FOLDERTYPE?: number;
}

export class CancelRemoveAppParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
  FOLDERTYPE?: number;
}

export class IntoGlobalSearchParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  STARTX?: number;
  STARTY?: number;
  ENDX?: number;
  ENDY?: number;
}

export class ExitGlobalSearchParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DURATION?: number;
}

export class IntoNegativeScreenParams {
  PNAMEID?: string;
  PVERSIONID?: string;
}

export class ExitNegativeScreenParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DURATION?: number;
}

export class UninstallAppParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  COMPONENT?: string;
  UNINSTALL?: string;
  FOLDERTYPE?: number;
  ISCARDFOLDER?: boolean;
}

export class DeleteAppParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  COMPONENT?: string;
}

export class SysEventInfoParams {
  BEHAVIOR_ID?: string;
  MSG?: string;
}

export class DelayReportParams {
  name?: string;
  timer?: number;
  msg?: Object;
}

export class WinDragToHotareaParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  CHANGEDWINDOWMODE?: number;
  CURRENTPKG?: string;
  WINDOWPOSITION?: number;
}

export class CurrentWindowNumParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  CURRENTWINDOWNUM?: number;
}

export class ScreenOnAnimationReportParams {
  BEGIN_TIME?: string;
  END_TIME?: string;
  E2E_LATENCY?: number;
}

// 通知中心和控制中心
export class NTFControlParams {
  PNAMEID?: string = ReportParams.PACKAGE_NAME;
  PVERSIONID?: string = ReportParams.PROCESS_NAME;
  TRACE_ID?: string;

  /**
   * 通知控制字段标识
   * 通过在某一位上设置1标识位标识特定业务类型，如25位置1表示用增消息
   */
  NOTIFICATION_CONTROL_FLAGS?: number;
}

// foldStatue
export class FoldStateParams extends NTFControlParams {
  FOLDDEVICETYPE?: number;
  ISFOLDEXPAND?: boolean;
}

export class NotificationPanelShow extends FoldStateParams {
  POINTX?: number;
  POINTY?: number;
  RESOLUTION?: string;
  TIMESTAMP?: string;
  ORIENTATION?: number;
  NUM?: number;
  IMPORTANTNUM?: number;
  MORENUM?: number;
  SCENARIOS?: string;
}

export class NotificationPanelHide extends FoldStateParams {
  DURATION?: string;
  TIMESTAMP?: string;
  ORIENTATION?: number;
}

export class ControlCenterShow extends NTFControlParams {
  POINTX?: number;
  POINTY?: number;
  RESOLUTION?: string;
  TIMESTAMP?: string;
  ORIENTATION?: number;
  LOCKSTATUS?: number;
  QUICKTOGGLEDATA?: string;
  SCREENTYPE?: number;
}

export class ControlCenterHide extends NTFControlParams {
  KEEPTIME?: number;
  TIMESTAMP?: string;
  ORIENTATION?: number;
  QUICKTOGGLEDATA?: string;
  TYPE?: number;
  LOCKSTATUS?: number;
  ANIMATIONBLURSTOPTIME?:number;
  SCREENTYPE?: number;
}

// 控制中心图标点击和长按
export class CCQuickToggleClick extends NTFControlParams {
  BUTTONNAME?: string;
  STATE?: string;
  LOCKSTATUS?: number;
  TIMESTAMP?: string;
  TYPE?: number;
  SCREENTYPE?: number;
}

export class CCQuickToggleLongClick extends NTFControlParams {
  BUTTON_NAME?: string;
  STATE?: string;
  LOCKSTATUS?: number;
  TIMESTAMP?: string;
  TYPE?: number;
  SCREENTYPE?: number;
}

export class CCQuickToggleClickSound extends NTFControlParams {
  NEWSTATE?: number;
  LOCKSTATUS?: number;
  TIMESTAMP?: string;
  SCREENTYPE?: number;
}

export class CCQuickToggleClickEBook extends NTFControlParams {
  NEWSTATE?: number;
  LOCKSTATUS?: number;
  TIMESTAMP?: string;
}

export class CCQuickToggleEyeComport extends NTFControlParams {
  NEWSTATE?: number;
  LOCKSTATUS?: number;
  TIMESTAMP?: string;
}

export class CCQuickToggleLongClickSound extends NTFControlParams {
  NEWSTATE?: number;
  LOCKSTATUS?: number;
  TIMESTAMP?: string;
}

export class CCQuickToggleLongClickEBook extends NTFControlParams {
  NEWSTATE?: number;
  LOCKSTATUS?: number;
  TIMESTAMP?: string;
}

export class CCSettingIconClick extends NTFControlParams {
  LOCK_STATUS?: number;
  TIMESTAMP?: string;
}

export class CCBrightnessSlide extends NTFControlParams {
  STARTPROGRESS?: number;
  STOPPROGRESS?: number;
  ISNIGHTMODE?: string;
  TIMESTAMP?: string;
  LOCKSTATUS?: number;
  SCREENTYPE?: number;
}

export class MoveIconInFolderParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  ISCARDFOLDER?: boolean;
  ISHIFOLDER?: boolean;
  FOLDERPOSITIONINDESKTOP?: string;
  FOLDERCONTENT?: string;
  PACKAGENAMES?: string;
  STARTPOSITION?: string;
  ENDPOSITION?: string;
  FOLDERID?: string;
  FOLDERTYPE?: number;
}

export class MoveIconInFolderBean {
  isCardFolder?: boolean;
  folderPositionInDesktop?: string;
  folderContent?: string;
  packageNames?: string;
  startPosition?: string;
  endPosition?: string;
  folderId?: string;
}

export class FolderSizeModifyParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  OPERATION?: string;
  RESULT?: string;
  FOLDERICONPOSITIONINDESKTOP?: string;
  FOLDERCONTENT?: string;
  FOLDERID?: string;
  ISHIFOLDER?: boolean;
  FOLDERTYPE?: number; // 0-普通文件夾, 1-非OpenHarmony化
}

export class FolderSizeModifyBean {
  operation?: string;
  result?: string;
  folderIconPositionInDesktop?: string;
  folderContent?: string;
  folderId?: string;
  iSHiFolder?: boolean;
  folderType?: number;
}

export class DragIconIntoFolderBean {
  iSBatch?: boolean;
  iSDragin?: boolean;
  draggingPackageNames?: string;
  isCardFolder?: boolean;
  folderPositionInDesktop?: string;
  folderContent?: string;
  iSHiFolder?: boolean;
  folderId?: string;
}

export class DragIconFromNotHarmonyFolderBean {
  isCardFolder?: boolean;
  folderPositionInDesktop?: string;
  folderContent?: string;
  folderId?: string;
  folderType?: number;
}

export class ScreenLockBaseThemeDataReportParams {
  THEMEID?: string;
  THEMENAME?: string;
  PNAMEID?: string = ReportParams.PACKAGE_NAME;
  PVERSIONID?: string = ReportParams.PROCESS_NAME;
}

export class ScreenLockSaveFormDataReportParams extends ScreenLockBaseThemeDataReportParams {
  FORMNUM?: number;
  DIMENSIONNUM?:number;
}

export class ScreenLockBaseFormDataReportParams extends ScreenLockBaseThemeDataReportParams {
  FORMID?: string;
  PACKAGENAME?: string;
  CARDDIMENSION?: string;
  MODULENAME?: string;
  FORMNAME?: string;
}

export class AddScreenLockFormDataReportParams extends ScreenLockBaseFormDataReportParams {
  LOCATION?: number;
}

export class ScreenLockFormDataReportParamsState extends ScreenLockBaseFormDataReportParams {
  FORMNUM?: number;
  RECOMMENDLOCATION?: string;
  DIMENSIONNUM?:number;
}

export class LiveViewReportParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  USER_PACKAGE_NAME?: string;
  LIVE_SCENARIO?: number;
  TEMPLATE_TYPE?: number;
  CAPSULE_TYPE?: number;
  NOTIFICATION_ID?: string;
}

export class LiveViewCardReportParams extends LiveViewReportParams {
  CARD_POSITION?: number;
}

/**
 * back手势打点参数
 */
export class BackEventParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  RESULT?: string;
  SIDE?: string;
  SCREEN_TYPE?: number;
  IS_MIDSCENE?: number;
  BUNDLENAME?: string;
}

export class FloatingDefaultParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE?: number;
  PKG_NAME?: string;
  APPS?: string;
}

export class StartFromOneStepParams extends FloatingDefaultParams {
  RESULT?: OperateResult;
  ORIENTATION?: number;
}

export class StartFromDockParams extends FloatingDefaultParams {
  START_TYPE?: number;
  SIZE_TYPE?: number;
}

export class StartFromRecentParams extends FloatingDefaultParams {
  SIZE_TYPE?: number;
}

export class FloatingToSplitParams extends FloatingDefaultParams {
  CHANGE_TYPE?: number;
  SPLIT_TYP?: number;
  FLOAT?: string;
  PRIMARY?: string;
  SECONDARY?: string;
}

export class SwichFloatingParams extends FloatingDefaultParams {
  SWICH_TYPE?: number;
}

export class MultiWindowDockSwitchParams extends FloatingDefaultParams {
  IS_ON?: boolean;
}

export class StartFromSideEdgeParams extends FloatingDefaultParams {
  FROM_TYPE?: number;
  SIDEBAR_LENGTH?: number;
}

export class ExpandTaskParams extends FloatingDefaultParams {
  SIDEBAR_LENGTH?: number;
}

export class DeleteTaskParams extends FloatingDefaultParams {
  INDEX?: number;
  DURATION?: number;
}

export class StartFromCallerParams extends FloatingDefaultParams {
  CALLEE_PKG_NAME?: string;
}

export class CloseFloatingParams extends FloatingDefaultParams {
  CLOSE_TYPE?: number;
}

export class MinFloatingParams extends FloatingDefaultParams {
  MIN_TYPE?: number;
  SIDEBAR_LENGTH?: number;
}

export class MaxFloatingParams extends FloatingDefaultParams {
  MAXMIZE_TYPE?: number;
}

export class ScaleFloatingParams extends FloatingDefaultParams {
  ORIGINAL_SCALE?: number;
  CURRENT_SCALE?: number;
  OPERATE_AREA?: number;
}

export class StartByBotifyParams extends FloatingDefaultParams {
  NOTIFY_TYPE?: number;
}

export enum SplitDisplayMode {
  UNFOLDED_PHONE,
  FOLD_DISPLAY_MODE_UNKNOWN,
  FOLD_DISPLAY_MODE_FULL,
  FOLD_DISPLAY_MODE_MAIN,
  FOLD_DISPLAY_MODE_SUB,
  FOLD_DISPLAY_MODE_COORDINATION,
}

export enum PairSplitResult {
  UNKNOWN,
  NO_SUPPORT_SPLIT,
  NO_SUPPORT_MULTI,
  PAIR_SPLIT
}

export enum SwitchType {
  UNKNOWN,
  MENU_UP_DOWM_SWAP,
  MENU_LEFT_RIGHT_SWAP
}

export enum OperateResult {
  FAIL,
  SUCCESS
}

export enum DeleteResult {
  MID,
  SPLIT,
  FULL
}

export enum ExitOneStepSplitReason {
  UNKNOWN,
  DRAG_DIVIDER_TO_EXIT,
  DRAG_DIVIDER_TO_FULL_SCREEN,
  BACK_GESTURE_TO_EXIT,
  BACK_GESTURE_TO_FULL_SCREEN,
  CLICK_TO_FULL_SCREEN,
  ROTATION_EXIT,
}

export enum TitleBarExitPairSplitReason {
  UNKNOWN,
  TITLE_BAR_TO_FULL_SCREEN,
  TITLE_BAR_TO_EXIT,
  TITLE_BAR_TO_FLOAT,
  TITLE_BAR_TO_SPLIT
}

export enum MenuAction {
  ENTER_FLOAT,
  ENTER_SPLIT,
  ENTER_MID_SCENE,
  CLOSE
}

export class EnterMidSceneFromRecent {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAYMODE?: SplitDisplayMode;
  MID_SCENE_TYPE?: number;
  RESULT?: OperateResult;
}

export class EnterOneStepSplitHotAreaParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
  DISPLAYMODE?: SplitDisplayMode;
  DURATION?: number;
}

export class EnterOneStepMidSceneHotAreaParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE?: number;
  DISPLAY_ORIENTATION?: number;
  PRIMARY_PKG?: string;
  SECOND_PKG?: string;
  DURATION?: number;
}

export class EnterOneStepMidSceneParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE?: number;
  DISPLAY_ORIENTATION?: number;
  PRIMARY_PKG?: string;
  SECOND_PKG?: string;
  TRIGGERTIMES?: number;
  RESULT?: OperateResult;
}

export class EnterMidSceneFromIconParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAYMODE?: number;
  DISPLAY_ORIENTATION?: number;
  ENTER_MID_WAIT_REASON?: number;
  PRIMARY?: string;
  SECONDARY?: string;
  CLICK_PKG?: string;
  CLICK_TYPE?: EnterMidSceneClickType;
  RESULT?: OperateResult;
}

export enum EnterMidSceneClickType {
  FROM_ICON,
  FROM_OTHER
}

export class EnterOneStepSplitParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
  TRIGGERTIMES?: number;
  DISPLAYMODE?: SplitDisplayMode;
  RESULT?: OperateResult;
  ORIENTATION?: number;
}

export class EnterPairSplitFromIconParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PRIMARY?: string;
  SECONDARY?: string;
  SPLITTYPE?: SplitType;
  DISPLAYMODE?: SplitDisplayMode;
  RESULT?: PairSplitResult;
}

export class EnterPairSplitFromDockParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  ORIPRIMARY?: string;
  ORISECONDARY?: string;
  ORISPLITTYPE?: SplitType;
  DISPLAYMODE?: SplitDisplayMode;
  FLOAT_1?: string;
  FLOAT_2?: string;
  RESULT?: PairSplitResult;
  CURPRIMARY?: string;
  CURSECONDARY?: string;
  CURSPLITTYPE?: SplitType;
  START_TYPE?: string;
}

export class AdjustPairSplitRatioParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PRIMARY?: string;
  SECONDARY?: string;
  SPLITTYPE?: SplitType;
  DISPLAYMODE?: SplitDisplayMode;
  FLOAT_1?: string;
  FLOAT_2?: string;
  ORIRATIO?: string;
  CURRATIO?: string;
}

export class SwapPairSplitLocParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PRIMARY?: string;
  SECONDARY?: string;
  SPLITTYPE?: SplitType;
  DISPLAYMODE?: SplitDisplayMode;
  FLOAT_1?: string;
  FLOAT_2?: string;
  RESULT?: OperateResult;
}

export class ExitOneStepSplitParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
  SPLITTYPE?: OneStepSplitType;
  DISPLAYMODE?: SplitDisplayMode;
  REASON?: ExitOneStepSplitReason;
}

export class ExitPairSplitParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PRIMARY?: string;
  SECONDARY?: string;
  SPLITTYPE?: SplitType;
  DISPLAYMODE?: SplitDisplayMode;
  FLOAT_1?: string;
  FLOAT_2?: string;
  EXITPACKAGENAME?: string;
}

export class TitleBarExitPairSplitParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PRIMARY?: string;
  SECONDARY?: string;
  SPLITTYPE?: SplitType;
  DISPLAYMODE?: SplitDisplayMode;
  FLOAT_1?: string;
  FLOAT_2?: string;
  PACKAGENAME?: string;
  REASON?: TitleBarExitPairSplitReason;
}

export class TitleBarClickParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
}

export class DividerClickParams {
  PNAMEID?: string;
  PVERSIONID?: string;
}

export class SplitToFloatParams extends FloatingDefaultParams {
  CHANGE_TYPE?: string;
  FULL?: string;
  FLOAT_1?: string;
  FLOAT_2?: string;
}

export class SplitStartFromCallerParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE?: number;
  CALLER?: string;
  CALLEE?: string;
  REQUESTED_SPLIT_MODE?: number;
  CALLER_WINDOW_MODE?: number;
  CALLER_RESULT_WINDOW_MODE?: number;
  CALLEE_RESULT_WINDOW_MODE?: number;
  SPLIT_TYPE?: number;
  ENTER_TYPE?: number;
}

export class SplitStartFromRecent {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE?: number;
  PRIMARY?: string;
  SECONDARY?: string;
  SPLIT_TYPE?: number;
}

export class DockAppCntParams {
  APP_CNT?: number;
  PNAMEID?: string;
  PVERSIONID?: string;
  SHORTCUT_CNT?: number;
}

export class StartAppFromDockParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DTYPE?: number;
  KEYNAME?: string;
}

export class OperationMenuParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DTYPE?: number;
  BUNDLENAME?: string;
}

export class EnterMidByGestureParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE?: number;
  DISPLAY_ORIENTATION?: number;
  FOCUS_PKG?: string;
  PKG_LIST?: string[];
  result?: OperateResult;
}

export class ExitMidByGestureParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE?: number;
  DISPLAY_ORIENTATION?: number;
  FOCUS_PKG?: string;
  FOCUS_WINDOW_SIZE?: number;
  PKG_LIST?: string[];
  result?: OperateResult;
}

export class StartAppFromPopupParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DTYPE?: number;
  KEYNAME?: string;
}

export class WindowStatisticsParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  WINDOW_CNT?: number;
}

export class CompletelyDeleteParams {
  DTYPE?: number;
  FTYPE?: number;
}

export class FullContinueAddingParams {
  DTYPE?: number;
}

export class PullRightMenuParams {
  DTYPE?: number;
}

export class DesktopItemsCountParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DTYPE?: number;
  APPCNT?: number;
  FCNT?: number;
  FDCNT?: number;
  FACNT?: number;
  SCCNT?: number;
  RFCNT?: number;
}

export class AppCenterItemsCountParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DTYPE?: number;
  PAGECNT?: number;
  SINGLEPAGEICONSCNT?: number[];
  SUMICONSCNT?: number;
}

export class DesktopRightMenuParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  MENU_TYPE?: number;
}

export class BigScreenSwipeChangeParams {
  PNAMEID: string;
  PVERSIONID: string;
  SWIPER_METHOD?: number;
}

export class StatusBarIconOperateParams {
  OTYPE?: number;
  FNCCODE?: string;
}

export class StatusBarMenuOperateParams {
  OTYPE?: number;
  FNCCODE?: string;
}

export class RemoveFromStatusBarParams {
  BUNDLE_NAME?: string;
  REASON?: string;
}

export class AccessPcStatusBarFailedParams {
  ERROR_INFO?: string;
  BUNDLE_NAME?: string;
  VERSIONID?: string;
}

export class PullAppCenterTypeParams {
  OTYPE?: number;
  PNAMEID?: string;
  PVERSIONID?: string;
}

export class OperatorAppCenterTypeParams {
  OTYPE?: string;
  PNAMEID?: string;
  PVERSIONID?: string;
}

export class GestureQuickSwitchParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  FROM?: string;
  START_POS?: number[];
  END_POS?: number[];
  DEVICE_STATUS?: number;
  ORIENTATION?: number;
  FROM_BUNDLE_NAME?: string;
  NEXT_BUNDLE_NAME?: string;
  FROM_IS_MIDSCENE?: number;
  TO_IS_MIDSCENE?: number;
}

export class OnClickAIBarParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  IS_ON?: boolean;
}

export class LongPressMisTouchParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  TYPE?: HiSysLongPressMisTouchType;
}

export class GestureDockShowParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  APPS?: string[];
  SIDE?: number;
}

export class DockDisappearParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  APPS?: string[];
  SIDE?: number;
  TIMEGAP?: number;
  MODE?: number;
}

export class EnterDockEditParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  TIME?: string;
  TYPE?: HiSysDockEditType;
}

export class AddAppToDockParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  BUNDLENAME?: string;
  SOURCE?: number;
}

export class DeleteAppFromDockParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  BUNDLENAME?: string;
}

export class SwapAppInDockParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  BUNDLENAME?: string;
  OLDINDEX?: number;
  NEWINDEX?: number;
}

export class ExitDockEditParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  TIME?: string;
  TYPE?: HiSysDockEditType;
}

export enum SwitchFreeMultiWindowModeReason {
  UNKNOWN,
  CONTROL_CENTER_TOGGLE_TYPE_CLICK_EVENT,
}

export class SwitchFreeMultiWindowModeParams {
  IS_ENTER?: boolean;
  SWITCH_REASON?: SwitchFreeMultiWindowModeReason;
  PNAMEID?: string = ReportParams.PACKAGE_NAME;
  PVERSIONID?: string = ReportParams.PROCESS_NAME;
}

export enum SwitchComputerModeReason {
  UNKNOWN,
  CONTROL_CENTER_TOGGLE_TYPE_CLICK_EVENT,
  CONTROL_CENTER_SELECT_CLICK_EVENT,
  SETTINGS,
}

export class SwitchComputerModeParams {
  IS_ENTER: boolean;
  SWITCH_REASON: SwitchComputerModeReason;
  PNAMEID?: string = ReportParams.PACKAGE_NAME;
  PVERSIONID?: string = ReportParams.PROCESS_NAME;
}

export class AiBarSettingSwitchParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  SWITCH_TYPE?: string;
  IS_ON?: boolean;
}

export class PiPAutoStartSwitchParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  IS_ON?: boolean;
}

export class RotationChangeParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  BUNDLENAME?: string;
  CURRENT_ROATION?: number;
  TARGET_ROATION?: number;
  ROTATION_TYPE?: string;
}

export class ScreenLockQuickToolParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  BUNDLENAME?: string;
  MODULENAME?: string;
  ABILITYNAME?: string;
  STARTMODE?: string;
  OPENSTATUS?: string;
  SCREEN_TYPE?: number;
}

export class TurboChargingParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  BATTRTYSOC?: string;
}

export class ClickSleepMenuFormDataReportParams {
  TRIGGER_EVENT_TYPE?: number;
  ACTION_EVENT_TYPE?: number;
}

export class PullHosKeyTypeParams {
  TYPE?: number;
  PNAMEID?: string;
  PVERSIONID?: string;
}

export class MidSceneDeleteWindowParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE?: number;
  DISPLAY_ORIENTATION?: number;
  FOCUS_PKG?: string;
  PKG_LIST?: string[];
  DELETE_TYPE?: number;
  RESULT?: DeleteResult;
  RESULT_PKG?: string[];
}

export class DoubleClickTitleParams {
  CURRENTPKG?: string;
  STATECHANGE?: number;
}

export class FoldExpandChangeParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE?: number;
  FOCUS_PKG?: string;
  PKG_LIST?: string[];
}

export class GuidanceDialogMidSceneParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE?: number;
  DISPLAY_ORIENTATION?: number;
  PKG_LIST?: string[];
  OPERATE_TYPE?: number;
  DIALOG_INDEX?: number;
}

export class GuidanceTipsMidSceneParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE?: number;
  DISPLAY_ORIENTATION?: number;
  PKG_LIST?: string[];
  OPERATE_TYPE?: number;
}

export class SkipOOBEParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  RESET_DATA_KEY?: string;
  RESET_DATA_VALUE?: string;
}

export class ReportProductionAppParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PRODUCTION_APP_INFO?: string;
}

export class MidSceneFoldAndExpandParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE_PRE?: number;
  DISPLAY_MODE_CUR?: number;
  DISPLAY_ORIENTATION?: number;
  FOCUS_PKG?: string;
  PKG_LIST?: string[];
}

export enum MidSceneDisplayMode {
  OTHERS,
  FOLD_EXPANDED,
  PAD,
  TRIFOLD_EXPANDED
}

export enum MidSceneDisplayModeFold {
  BAR_DEVICE,
  FOLD_DEVICE,
  TRIFOLD_DEVICE
}

export enum MidSceneDisplayModeTriFold {
  TRIFOLD_M,
  TRIFOLD_G
}

export enum MidSceneAdjustType {
  ADJUST_TYPE_CLICK,
  ADJUST_TYPE_THREE_FINGER_SWIPE
}

export enum ReplacedTypeMode {
  WAITING_ON_LEFT,
  WAITING_ON_RIGHT,
  WAITING_ON_MID,
}

export enum MidSceneAddType {
  ADD_FROM_APP,
}

export enum BatchEnterSplitOrMidSceneType {
  SPLIT,
  MID_SCENE
}

export class MidSceneMaximizeParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE?: number;
  DISPLAY_ORIENTATION?: number;
  FOCUS_PKG?: string;
  PKG_LIST?: string[];
  FOCUS_WINDOW_SIZE?: number;
}

export class EnterMidFromSplitParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE?: number;
  DISPLAY_ORIENTATION?: number;
  PRIMARY_SPLIT?: string;
  SECONDARY_SPLIT?: string;
  FLOAT_PKG?: string;
  PRIMARY_WINDOW_SIZE?: number;
  SECOND_WINDOW_SIZE?: number;
  FLOAT_WINDOW_SIZE?: number;
}

export class EnterMidFromSplitClickParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE?: number;
  DISPLAY_ORIENTATION?: number;
  PRIMARY?: string;
  SECONDARY?: string;
}

export class EnterMidFromSplitIconParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAYMODE?: number;
  DISPLAY_ORIENTATION?: number;
  PRIMARY?: string;
  SECONDARY?: string;
  CLICK_TYPE?: EnterMidSceneClickType;
  RESULT?: OperateResult;
}

export class DragTitleBarSwapInMidscene {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE?: number;
  DISPLAY_ORIENTATION?: number;
  DRAG_PKG?: string;
  DRAG_BEFORE_POS?: number;
  DRAG_AFTER_POS?: number;
  PKG_LIST?: string[];
}

export class DragContentInMidscene {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE?: number;
  DISPLAY_ORIENTATION?: number;
  FROM_PKG?: string;
  TO_PKG?: string;
}

export class ReplaceFullMidParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DISPLAY_MODE?: number;
  DISPLAY_ORIENTATION?: number;
  FOCUS_PKG?: string;
  PKG_LIST?: string[];
  ENTER_PKG?: string;
  REPLACE_PKG?: string;
  REASON?: ReplaceReason;
}

export class SearchAppPositionParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  COMPONENT?: string;
  SHORTCUTID?: string;
}

export class IntoOneHandModeParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  FROM?: string;
  START_POS?: number[];
  INTO_ONE_HAND_POS?: number[];
  MODE_TYPE?: string;
  APP_BUNDLE_NAME: string | undefined;
}

export class IconItemsClickParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  BUNDLENAME?: string;
  PLUGINSLOT?: string;
  DESKSTYLE?: number;
}

export class IconItemsNumberChangeParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  COUNT?: number;
}

export class AddBlankPageParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PAGE_COUNT_AFTER_ADD?: number;
}

export class DeleteBlankPageParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PAGE_COUNT_AFTER_DELETE?: number;
  LAUNCHERTYPE?: number;
}

export class DragPageParams {
  PNAMEID?: string;
  PVERSIONID?: string;
}

export class StateChangeParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PC_CURRENT_STATE?: number;
  PC_NEXT_STATE?: number;
}

// 进入退出虚拟机旋转锁定事件打点参数
export class RotationLockParams {
  PNAMEID: string;
  PVERSIONID: string;
  IS_LOCKED: boolean;
}

export class CloseWindowParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  CURRENTPKG?: string;
}

export class FullScreenWaterFallModeParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  CURRENTPKG?: string;
}

export class PinchGestureEventParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  CURRENTPKG?: string;
  FINGERS_NUMBER?: number;
  MODE_CHANGE_TYPE?: string;
}

export class BorCWindowsNumbersParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  B_WINDOWS_NUMBERS?: number;
  C_WINDOWS_NUMBERS?: number;
}

export class DeleteOuterShortcutParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
  SHORTCUTID?: string;
}

export class AddOuterShortcutParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
  SHORTCUTID?: string;
  TYPE?: number;
}

export class AddOuterAppParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  PACKAGENAME?: string;
  TYPE?: number;
}

export class AntiPeepingStatusParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  SWITCH_WHERE?: string;
  SWITCH_TYPE?: string;
  SWITCH_RESULT?: number;
}

export class UnlockFailedParams {
  ERROR_CODE?: number;
}

export class AccountAbnormalParams {
  INTERFACE_NAME?: string;
  ERROR_CODE?: number;
}

export class SwitchDesktopFourFingerSwipeParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DURATION?: number;
  DISTANCE?: number;
}

export class RDBAbnormalParams {
  ERROR_CODE?: string;
  ERROR_MSG?: string;
  SCENE_MSG?: string;
  TABLE_NAME?: string;
  EXTRA?: string;
  BUNDLE_NAME?: string;
}

export class CacheAbnormalParams {
  SCENE_MSG?: string;
  ERROR_MSG?: string;
}

export class RefreshAbnormalParams {
  SCENE_MSG?: string;
  ERROR_MSG?: string;
}

export class ReportFolderCreationOpenRecommendParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  DIALOGAPPCO?: number;
  FOLDERID?: string;
  FOLDERTYPE?: number;
}

export class ReportFolderCreationRecommendOkParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  FOLDERID?: string;
  FOLDERTYPE?: number;
  CHOOSECOUN?: number;
  APPCATEGORY?: string;
  AREA?: string;
}

export class ReportFolderCreationRecommendCancelParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  FOLDERID?: string;
  FOLDERTYPE?: number;
}

export class ReportFolderAddAppRecommendOkParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  FOLDERID?: string;
  FOLDERTYPE?: number;
  CHOOSECOUN?: number;
  APPCATEGORY?: string;
  AREA?: string;
}

export class ReportFolderAddAppRecommendCancelParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  FOLDERID?: string;
  FOLDERTYPE?: number;
}

export class IconLostAbnormalParams {
  BUNDLE_NAME: string;
  ERROR_MSG: string;
  EXTRA?: string;
}

export class IconStatusAbnormalParams {
  BUNDLE_NAME: string;
  ERROR_MSG: string;
  EXTRA: string | undefined;
}

export class SwitchingDesktopFourFingerSwipeParams {
  PNAMEID: string;
  PVERSIONID: string;
  DURATION: number;
  DISTANCE: number;
}

export class ForceMultiWindowSwitchParams {
  PNAMEID: string;
  PVERSIONID: string;
  SINGLESWITCH: number;
  ALLSWITCH: number;
  APPLIST: string;
}

export class ForceMultiWindowSwitchWeeklyParams {
  PNAMEID: string;
  PVERSIONID: string;
  APPLIST: string;
}

export class UIExceptionParams {
  REASON?: string;
}

export class BackgroundBlurExceptionParams extends UIExceptionParams {
  BLUR_SCALE?: number;
  BLUR_COLOR?: string;
}

export class ClearAllIconExceptionParams extends UIExceptionParams {
  RECENT_STATE?: string;
}

export class FollowingAppExceptionParams extends UIExceptionParams {
  ORIGINAL_NAME?: string;
  NEW_NAME?: string;
}

export class BaseParams {
  PNAMEID?: string;
  PVERSIONID?: string;
}

export class ReportCardFaultInformationParams {
  // 故障信息，用于区分不同故障点
  FAULTINFORMATION: string;
  FORMID: string;
  BUNDLENAME: string;
  MODULENAME: string;
  FORMNAME: string;
  SIZE: string;
  POSITION: string;
  SOURCETYPE: string;
  // 卡片类型，0-普通卡片 1-互动卡片-场景动效 2-互动卡片-趣味交互
  FORMTYPE: number;
  // 卡片位置来源 0表示桌面 1表示卡片中心
  FORMLOCATION: number;
  // 上报错误类型 0：正常 1 error 2 uninstall 3 onterminated id 4 invalid id 5 others
  RESULTTYPE: number;
  // 报错信息
  ERRORMSG?: string;
  // 数据库操作信息
  OPERATEMSG?: string;
  // 堆叠卡片列表
  FORMLIST?: Array<string>;
}

export class ReportCardFaultInformationEvent {
  faultInformation: string;
  formId: string;
  bundleName: string;
  moduleName: string;
  formName: string;
  area: number[];
  position: string;
  sourceType: string;
  formType: number;
  location: number;
  resultType: number;
  errorMsg?: string;
  operateMsg?: string;
  formList?: string[];
}

export enum ErrorCardResultType {
  SUCCESS,
  ONERROR,
  ONUNINSTALL,
  ONTERMINATED,
  INVALIDID,
  OTHERS,
}

export enum FormLocationType {
  DESKTOP,
  FORMCENTER,
}

export class EnterDrawerModeParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  ENTER_TYPE?: number;
}

export class ExitDrawerModeParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  EXIT_TYPE?: number;
}

export class VmUsingTimeParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  VM_STATE?: string;
  TIME_DATA?: number[];
}

export class SystemSceneStateParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  SYSTEM_SCENE_STATE?: string;
}

export class BatchEnterSplitOrMidSceneParams {
  PNAMEID: string;
  PVERSIONID: string;
  DISPLAYMODE: number;
  REASON: number;
  PKG_LIST: string[];
  ENTERTYPE: number;
}

export class DockAutoHideParams {
  PNAMEID: string;
  PVERSIONID: string;
  SWITCH_STATE: boolean;
}