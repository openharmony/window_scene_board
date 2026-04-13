/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { NotificationEntry } from '../../model/NotificationEntry';
import { NotificationType } from '../../common/NotificationType';
import { NtfSettingsDialogVM } from '../../vm/NtfSettingsDialogVM';
import { ntfMgr } from '../../model/NotificationManager';
import { NotificationPanelManager } from '../../model/NotificationPanelManager';
import { ntfSettingsDC as NtfSettingsDC } from '../../controller/NtfSettingsDialogController';
import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { HiDfxEventUtil, HiSysDataOperationType, sSettingsUtil } from '@ohos/frameworkwrapper';
import { ExtAppConstants } from '@ohos/commonconstants';
import { ResUtils } from '@ohos/windowscene';
import CommonEventManager from '@ohos.commonEventManager';
import base from '@ohos.base';
import { ScreenLockApi } from '@ohos/screenlockcommon/src/main/ets/api/ScreenLockApi';
import { NotificationConstants } from '../../common/NotificationConstants';
import {
  fontScaleManager,
  FontScaleState,
  LogWithHa,
  NotificationSysEventReporter,
  OtherBaseTemplate
} from '@ohos/systemuicommon';
import { DropDownPanelConstants, DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { AccessibilityUtil } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { notificationConfigManager } from '../../manager/NotificationConfigManager';
import { screenLockBlurButtonVM, ScreenLockBlurButtonVM } from '../../vm/ScreenLockBlurButtonVM';
import {
  ClickNotificationErrorCode,
  ClickNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { ntfViewConfigManager } from '../../vm/config/NtfViewConfigManager';
import { bundleManager } from '@kit.AbilityKit';
import { NotificationApiUtil } from '../../utils/NotificationApiUtil';
import { NotificationSettingMenuType } from '@ohos/systemuicommon/newIndex';
import { NtfSettingManagerUtils, SwitchState } from '@ohos/systemuicommon/newTsIndex';
import { CommonExceptionCode } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionCode';

const TAG = 'NtfSettingsDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const COMPONENT_ID_CLOSE = TAG + '_Button_close';
const COMPONENT_ID_SILENCE_NTF = TAG + '_Button_silence_ntf';
const COMPONENT_ID_TOP = TAG + '_Button_top';
const COMPONENT_ID_SETTING = TAG + '_Button_setting';
const COMPONENT_ID_OPEN_APP_NTF_MGMT = TAG + '_Open_app_ntf_mgmt';
const FONT_FAMILY = 'HarmonyHeiTi';

interface MenuConfig {
  content: ResourceStr;
  id: string;
  margin?: Margin;
  onClick: () => void;
  type?: NotificationSettingMenuType;
}

interface DividerConfig {
  isVisibility: boolean;
}

const ZERO_USER_ID: number = 0;

/**
 * 通知设置弹框
 *
 * @since 2023-01-13
 */
@Component
export struct NtfSettingsDialog {
  /**
   * 通知数据
   */
  @State ntfEntry: NotificationEntry | undefined = undefined;
  @State isDisplayAtTop: boolean = false;
  @Consume @Watch('refreshNtfSettingDialog') ntfSettingsDialogClose: boolean;
  /**
   * 长辈模式字体
   */
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  /*
   * 按压时隐藏分割线
   */
  @State hideDividerBetweenCloseAndTop: boolean = false;
  @State hideDividerBetweenTopAndSetting: boolean = false;
  /**
   * 面板类型，默认下拉面板
   */
  private ntfType: number = NotificationType.TYPE_PHONE_DROPDOWN;
  /**
   * 弹框VM
   */
  private dialogVM?: NtfSettingsDialogVM;
  private changeAppPinTopConfig?: (enable: boolean) => void;
  private changeSilenceConfig?: (isSilence: boolean) => void;

  // 菜单颜色map：正常态和按压态
  @State menuConfigBgMap: Map<string, ResourceColor> = new Map();

  liveTemplate: OtherBaseTemplate| undefined = undefined;
  /**
   * 背景模糊VM
   */
  @State screenLockBlurButtonVM: ScreenLockBlurButtonVM = screenLockBlurButtonVM;
  /**
   * 静默提醒
   */
  @State isSilent: boolean = false;
  @State silenceDialogFlag: boolean = false;
  // 应用内通知管理AbilityName
  private appNtfMgmtAbilityName?: string;
  getNtfEntry(): NotificationEntry {
    return this.ntfEntry as NotificationEntry;
  }

  async aboutToAppear(): Promise<void> {
    // 初始化
    this.dialogVM?.init(this);
    // 初始化通知数据
    this.ntfEntry = (this.dialogVM as NtfSettingsDialogVM)?.getNtfEntry();
    this.liveTemplate = this.ntfEntry?.liveViewData?.template as OtherBaseTemplate;
    this.appNtfMgmtAbilityName = NotificationApiUtil.getAppNtfMgmtAbilityName(this.ntfEntry.creatorBundleName);
    this.isDisplayAtTop = this.ntfEntry?.isDisplayAtTop;
    log.showInfo(`init ntfEntry:${this.ntfEntry?.creatorBundleName} ${this.ntfEntry?.isDisplayAtTop}
      ${this.ntfEntry?.bundleType} ${this.ntfEntry?.agentBundle?.bundle}`);
    if (!CommonUtils.isInvalid(this.ntfEntry)) {
      log.showInfo('ntfSettingsDialogClose:' + this.ntfSettingsDialogClose)
      this.ntfSettingsDialogClose = false;
      await this.getSilenceState(this.ntfEntry.creatorBundleName, this.ntfEntry.creatorUid);
    }
    this.initMenuItemBgColor();
    this.showDivider();
    AccessibilityUtil.requestFocusAccessibility(TAG + '_AppName');
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear')
    this.ntfSettingsDialogClose = true;
    this.dialogVM?.onDestroy();
  }

  refreshNtfSettingDialog(): void {
    log.showInfo('refreshNtfSettingDialog,ntfSettingsDialogClose:' + this.ntfSettingsDialogClose)
    if (this.ntfSettingsDialogClose) {
      NtfSettingsDC.hideDialog(this.ntfType);
    }
  }

  initMenuItemBgColor(): void {
    const menuItemArr = [COMPONENT_ID_CLOSE, COMPONENT_ID_SILENCE_NTF, COMPONENT_ID_TOP, COMPONENT_ID_SETTING];
    for (let i = 0; i < menuItemArr.length; i++) {
      this.menuConfigBgMap.set(menuItemArr[i], $r('app.color.menu_item_default_bg_color'));
    }
  }

  onBackPress(): boolean {
    log.showInfo('onBackPress');
    return true;
  }

  /**
   * 弹框通知数据切换回调
   * SettingsDialogCallback
   *
   * @param ntfEntry 通知数据
   */
  onNtfEntryChange(ntfEntry: NotificationEntry): void {
    this.ntfEntry = ntfEntry;
    this.isDisplayAtTop = this.ntfEntry?.isDisplayAtTop;
    log.showInfo(`onNtfEntryChange ntfEntry:${this.ntfEntry?.creatorBundleName} ${this.ntfEntry?.isDisplayAtTop}`)
  }

  getTitleResource(): Resource {
    return this.ntfEntry?.isLiveType() && !this.ntfEntry.isConvertFromNormal ?
    $r('app.string.live_view_setting_dialog_title') : $r('app.string.ntf_setting_dialog_title');
  }

  printNameWarnLogs(): void {
    if (this.ntfEntry?.isInAggregate || ResUtils.getInnerStringNumS(this.getTitleResource(), this.ntfEntry?.appLabel)) {
      return;
    }
    log.showWarn('getAppName fail');
  }

  private getAppName(): string {
    this.printNameWarnLogs();

    if (this.ntfEntry?.isInAggregate) {
      return ResUtils.getInnerString($r('app.string.smart_digest_setting_dialog_title'));
    }
    if (this.isUninstallMetaServiceLive()) {
      log.showInfo(TAG, `unstall meta service live bundlename ${this.liveTemplate?.uninstallMetaSerBundleName}`);
      return ResUtils.getInnerStringNumS($r('app.string.live_view_setting_dialog_title'),
        this.liveTemplate?.uninstallMetaSerBundleName ?? '')
    }
    return ResUtils.getInnerStringNumS(
      this.ntfEntry?.isLiveType() && !this.ntfEntry.isConvertFromNormal ? $r('app.string.live_view_setting_dialog_title') : $r('app.string.ntf_setting_dialog_title'),
      this.ntfEntry?.appName?.value);
  }

  private getOpenAppNtfMgmtTitle() {
    return ResUtils.getInnerStringNumS($r('app.string.open_app_inner_ntf_mgmt'), this.ntfEntry?.appName?.value);
  }

  @Builder
  buildSmartDigestMenus() {
    this.buildMenu({
      content: $r('app.string.close_smart_digest'),
      id: COMPONENT_ID_CLOSE,
      margin: { top: $r('app.float.ntf_settings_dialog_menu_item_margin') },
      onClick: this.onClickCloseSmartDigest,
      type: NotificationSettingMenuType.CLOSE,
    })
  }

  build() {
    if (!CommonUtils.isInvalid(this.ntfEntry)) {
      Column() {
        this.buildTitle()
        if (this.isLiveView()) {
          this.buildLiveViewMenu()
        } else if (this.ntfEntry?.isInAggregate) {
          this.buildSmartDigestMenus()
        } else {
          this.buildNotificationMenus()
        }
      }
      .width($r('app.float.ntf_settings_dialog_width'))
      .borderRadius($r('app.float.ntf_settings_dialog_border_radius'))
      .visibility(this.screenLockBlurButtonVM.getIsDialogDirectHidden() ? Visibility.None : Visibility.Visible)
    }
  }

  @Builder
  buildTitle() {
    // 弹窗应用标题
    Text(this.getAppName())
      .draggable(false)
      .id(TAG + '_AppName')
      .fontSize($r('app.float.ntf_title_font_size'))
      .maxFontScale(2)
      .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      .fontWeight(FontWeight.Medium)
      .fontFamily(FONT_FAMILY)
      .width('100%')
      .constraintSize({ minHeight: $r('app.float.ntf_settings_dialog_app_name_height') })
      .padding({
        left: $r('app.float.ntf_item_padding_start_end'),
        right: $r('app.float.ntf_item_padding_start_end'),
        top: $r('app.float.ntf_settings_dialog_app_name_margin_top')
      })
  }

  @Builder
  buildMenu(menuConfig: MenuConfig) {
    // 关闭此应用通知/实况窗/元服务通知
    MenuItem() {
      Text(menuConfig.content)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .maxFontScale(2)
        .fontWeight(FontWeight.Medium)
        .fontFamily(FONT_FAMILY)
        .constraintSize({
          minHeight: $r('app.float.ntf_settings_dialog_menu_item_height')
        })
        .width('100%')
        .fontColor(menuConfig.type === NotificationSettingMenuType.CLOSE ? $r('sys.color.ohos_id_color_warning') :
          undefined)
        .padding({
          top: $r('app.float.ntf_content_padding_start_end'),
          bottom: $r('app.float.ntf_content_padding_start_end')
        })
    }
    .id(menuConfig.id)
    .width('100%')
    .contentFontColor($r('sys.color.ohos_id_color_text_primary'))
    .margin(menuConfig.margin)
    .borderRadius($r('app.float.ntf_settings_dialog_menu_item_border_radius'))
    .padding({
      left: $r('app.float.ntf_content_padding_start_end'),
      right: $r('app.float.ntf_content_padding_start_end')
    })
    .backgroundColor(this.getMenuItemBgById(menuConfig.id))
    .onClick(menuConfig.onClick)
    .onTouch((event) => {
      if (event.type === TouchType.Down) {
        this.hideDivider(menuConfig);
        this.menuConfigBgMap.set(menuConfig.id, $r('sys.color.ohos_id_color_click_effect'));
      } else if (this.isBeyondArea(event)) {
        this.showDivider();
        this.menuConfigBgMap.set(menuConfig.id, $r('app.color.menu_item_default_bg_color'));
      }
    })
  }
  getMenuItemBgById(menuConfigId: string): ResourceColor | undefined {
    return this.menuConfigBgMap.get(menuConfigId);
  }

  @Builder
  buildLiveViewMenus() {
    // 关闭此应用实况窗
    this.buildMenu({
      content: $r('app.string.ntf_close_pkg_live_view'),
      id: COMPONENT_ID_CLOSE,
      margin: { top: $r('app.float.ntf_settings_dialog_menu_item_margin') },
      onClick: this.onClickClose,
      type: NotificationSettingMenuType.CLOSE,
    })
  }

  @Builder
  buildMetaSerLiveViewMenus() {
    // 关闭此元服务实况窗
    this.buildMenu({
      content: $r('app.string.ntf_close_meta_service_live_view_notification'),
      id: COMPONENT_ID_CLOSE,
      margin: { top: $r('app.float.ntf_settings_dialog_menu_item_margin') },
      onClick: this.onClickClose
    })
  }

  @Builder
  buildDivider(dividerConfig: DividerConfig) {
    Divider()
      .vertical(false)
      .color($r('sys.color.ohos_id_color_list_separator'))
      .visibility(dividerConfig.isVisibility ? Visibility.Hidden : Visibility.Visible)
      .margin({
        left: $r('app.float.ntf_content_padding_start_end'),
        right: $r('app.float.ntf_content_padding_start_end')
      })
  }

  @Builder
  buildNotificationMenus() {
    // 跳转到应用内通知管理
    if (this.appNtfMgmtAbilityName) {
      this.buildMenu({
        content: this.getOpenAppNtfMgmtTitle(),
        id: COMPONENT_ID_OPEN_APP_NTF_MGMT,
        margin: {
          top: $r('app.float.ntf_settings_dialog_menu_item_margin'),
          bottom: (this.isCloseNtfBtnShow() || this.isTopNtfShow()) ? 0 :
          $r('app.float.ntf_settings_dialog_menu_item_margin')
        },
        onClick: this.onClickOpenAppNtfMgmt
      })
      this.buildDivider({ isVisibility: this.hideDividerBetweenCloseAndTop });
    }
    // 关闭此应用通知或者元服务通知
    if (this.isCloseNtfBtnShow()) {
      this.buildMenu({
        content: this.isMetaService() ? $r('app.string.ntf_close_meta_service_notification')
          : $r('app.string.ntf_close_pkg_notification'),
        id: COMPONENT_ID_CLOSE,
        margin: {
          top: this.appNtfMgmtAbilityName ? 0 : $r('app.float.ntf_settings_dialog_menu_item_margin'),
          bottom: this.isTopNtfShow() ? 0 : $r('app.float.ntf_settings_dialog_menu_item_margin')
        },
        onClick: this.onClickClose,
        type: NotificationSettingMenuType.CLOSE,
      })
      this.buildDivider({ isVisibility: this.hideDividerBetweenCloseAndTop });
    }

    // 静默提醒
    if (this.isMoreSettingBtnShow()) {
      this.buildMenu({
        content: this.isSilent ? $r('app.string.disable_silent_notifications') :
        $r('app.string.silence_app_notifications'),
        id: COMPONENT_ID_SILENCE_NTF,
        margin: {
          top: this.isCloseNtfBtnShow() ? 0 : $r('app.float.ntf_settings_dialog_menu_item_margin'),
        },
        onClick: this.onSilenceClick
      })
      this.buildDivider({ isVisibility: this.hideDividerBetweenTopAndSetting });
    }

    // 置顶此应用通知
    if (this.isTopNtfShow()) {
      this.buildMenu({
        content: this.isDisplayAtTop
          ? $r('app.string.ntf_cancel_pin_top_pkg_notification')
          : $r('app.string.ntf_pin_top_pkg_notification'),
        id: COMPONENT_ID_TOP,
        margin: {
          top: this.isMoreSettingBtnShow() ? 0 : $r('app.float.ntf_settings_dialog_menu_item_margin'),
          bottom: this.isMoreSettingBtnShow() ? 0 : $r('app.float.ntf_settings_dialog_menu_item_margin')
        },
        onClick: this.onClickPinPop
      })
      this.buildDivider({ isVisibility: this.hideDividerBetweenTopAndSetting });
    }

    // 更多设置
    if (this.isMoreSettingBtnShow()) {
      this.buildMenu({
        content: $r('app.string.ntf_dialog_more_settings'),
        id: COMPONENT_ID_SETTING,
        onClick: () => {
          this.ntfSettingsDialogClose = true;
          this.clickMoreSetting();
        }
      })
    }
  }

  @Builder
  buildLiveViewMenu() {
    if (this.isUninstallMetaServiceLive()) {
      this.buildMetaSerLiveViewMenus()
    } else if (this.ntfEntry?.liveViewData?.isAtomicServiceFromPush) {
      this.buildMetaLiveViewNotificationMenus()
    } else {
      this.buildLiveViewMenus()
    }
  }

  @Builder
  buildMetaLiveViewNotificationMenus() {
    // 关闭此元服务通知
    if (this.isCloseNtfBtnShow()) {
      this.buildMenu({
        content: $r('app.string.ntf_close_meta_service_live_view_notification'),
        id: COMPONENT_ID_CLOSE,
        margin: { top: $r('app.float.ntf_settings_dialog_menu_item_margin') },
        onClick: this.onMetaServiceClickClose,
        type: NotificationSettingMenuType.CLOSE
      })
    }
  }

  /**
   * 判断触摸点是否超出当前控件范围。
   */
  private isBeyondArea(event: TouchEvent): boolean {
    let xOutOfRange = event.touches[0].x < 0 || event.touches[0].x > event.target.area.width;
    let yOutOfRange = event.touches[0].y < 0 || event.touches[0].y > event.target.area.height;
    return xOutOfRange || yOutOfRange;
  }

  private showDivider(): void {
    this.hideDividerBetweenCloseAndTop = false;
    this.hideDividerBetweenTopAndSetting = false;
  }

  private hideDivider(menuConfig: MenuConfig): void {
    this.hideDividerBetweenCloseAndTop = menuConfig.id === COMPONENT_ID_CLOSE || menuConfig.id === COMPONENT_ID_TOP;
    this.hideDividerBetweenTopAndSetting = menuConfig.id === COMPONENT_ID_TOP || menuConfig.id === COMPONENT_ID_SETTING;
  }

  /**
   * 是否是实况窗通知
   * @returns
   */
  private isLiveView(): boolean {
    return Boolean(this.ntfEntry?.isLiveType() && !this.ntfEntry?.isConvertFromNormal);
  }

  /**
   * 是否push发送的元服务通知
   * @returns
   */
  private isMetaService(): boolean {
    return Boolean(this.ntfEntry?.isFromPush && this.ntfEntry?.bundleType === bundleManager.BundleType.ATOMIC_SERVICE);
  }

  private isCloseNtfBtnShow(): boolean {
    if (this.ntfEntry === null) {
      return true;
    }
    if (ArrayUtils.contains(
      NotificationConstants.DISABLE_CLOSE_NOTIFICATION_PACKAGE_NAME,
      this.ntfEntry?.creatorBundleName!) ||
        NotificationConstants.DISABLE_CLOSE_BUTTON_PACKAGE_NAME.has(this.ntfEntry?.creatorBundleName!)) {
      return false;
    }
    return true;
  }

  private isMoreSettingBtnShow(): boolean {
    if (this.ntfEntry && ArrayUtils.contains(NotificationConstants.DISABLE_CLOSE_NOTIFICATION_PACKAGE_NAME,
      this.ntfEntry.creatorBundleName!)) {
      return false;
    }
    return true;
  }

  /**
   * 是否显示置顶通知按钮
   *
   * @returns true显示
   */
  private isTopNtfShow(): boolean {
    return !this.isMetaService();
  }

  private getClickRegion(): ClickRegion {
    if (this.isLiveView()) {
      return ClickRegion.CLOSE_LIVE_VIEW_ENABLE;
    } else if (this.isMetaService()) {
      return ClickRegion.CLOSE_META_SERVICE_NTF_ENABLE;
    } else {
      return ClickRegion.CLOSE_NTF_ENABLE;
    }
  }

  private onClickClose = () => {
    log.showInfo('click close ntf button: ' + this.ntfType + ', ' + this.ntfEntry?.toSimpleString());
    ClickNotificationMaintenance.saveInfo({
      data: this.ntfEntry,
      clickRegion: this.getClickRegion(),
    });
    if (this.ntfEntry) {
      if (this.isLiveView()) { // 实况通知
        if (this.isUninstallMetaServiceLive()) {
          // 调用元服务接口，关闭未安装元服务通知
          ntfMgr.setUnstallMetaServiceLiveEnable(this.ntfEntry?.creatorBundleName, this.ntfEntry?.creatorUid, false);
          // 删除未安装元服务实况卡片
          this.closeUninstallMetaServiceLive()
        } else {
          ntfMgr.setLiveViewEnable(this.ntfEntry?.creatorBundleName, this.ntfEntry?.creatorUid, false);
        }
      } else if (this.isMetaService()) { // 元服务通知
        ntfMgr.setMetaServiceNotificationEnable(this.ntfEntry?.creatorBundleName, this.ntfEntry?.creatorUid, false);
      } else { // 普通通知
        // 关闭置顶
        notificationConfigManager.setPinTopState(this.ntfEntry?.creatorUid, false).then((isSuccess: boolean) => {
          if (!isSuccess) {
            ClickNotificationMaintenance.updateErrorCode(ClickNotificationErrorCode.SET_PIN_TOP_FAIL);
          }
        });
        // 关闭通知
        ntfMgr.enablePkgNotification(this.ntfEntry?.creatorBundleName, this.ntfEntry?.creatorUid, false);
      }
      AccessibilityUtil.sendAccessibility(this.isLiveView() ?
        ResUtils.getInnerString($r('app.string.nc_accessibility_close_live_view')) :
        ResUtils.getInnerString($r('app.string.nc_accessibility_close_notification')));
    } else {
      log.showWarn('click close ntf button, but no ntfEntry');
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.NO_ENTRY);
    }
    this.clickCloseEventReporter();
    this.ntfSettingsDialogClose = true;
  }

  /**
   * 是否是未安装的元服务实况
   */
  private isUninstallMetaServiceLive(): boolean {
    return Boolean(!this.liveTemplate?.isInstallMetaSer && this.ntfEntry?.isLiveType());
  }

  /**
   * 关闭未安装元服务实况开关
   */
  private closeUninstallMetaServiceLive = (): void => {
    if (this.ntfEntry) {
      ntfMgr.removeNotificationByCancel(this.ntfEntry)
    }
  };

  private onMetaServiceClickClose = () => {
    log.showInfo('click close meta service ntf button: ' + this.ntfType + ', ' + this.ntfEntry?.toSimpleString());
    ClickNotificationMaintenance.saveInfo({
      data: this.ntfEntry,
      clickRegion: ClickRegion.CLOSE_LIVE_VIEW_ENABLE,
    });
    ntfMgr.setLiveViewEnable(this.ntfEntry?.creatorBundleName!, this.ntfEntry!.creatorUid, false);
    this.clickCloseEventReporter();
    this.ntfSettingsDialogClose = true;
    this.publishMetaServiceCloseEvent();
  }

  private clickCloseEventReporter = () => {
    if (this.ntfEntry != undefined) {
      HiDfxEventUtil.reportNtfMenuClickDisableNtf(this.ntfEntry?.creatorBundleName, this.ntfEntry?.id);
      NotificationSysEventReporter.notificationPanelSlipSettingClose({
        NOTIFICATION_SLOT_TYPE: this.ntfEntry?.slotType,
        CREATOR_BUNDLE_NAME: this.ntfEntry?.creatorBundleName,
        TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
        NOTIFICATION_ID: this.ntfEntry?.id,
        BUNDLE_TYPE: this.ntfEntry?.bundleType,
        TRACE_ID: this.ntfEntry?.traceId
      });
    }
  }

  private onClickCloseSmartDigest = () => {
    log.showInfo('click close smart digest: ' + this.ntfType + ', ' + this.ntfEntry?.toSimpleString());
    sSettingsUtil.setSecureValue(NotificationConstants.UNIFIED_GROUP_ENABLE, 'false');
    this.ntfSettingsDialogClose = true;
    NotificationSysEventReporter.ntfSmartDigestClose({
      TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      AGGREGATION_SCENE: this.ntfEntry?.aggregateContent?.sceneName
    });
  }
  private onSilenceClick = async (): Promise<void> => {
    if (!this.ntfEntry) {
      return;
    }
    this.silenceDialogFlag = this.isSilent;
    try {
      const result =
        await NtfSettingManagerUtils.isSilentReminderEnabled(this.ntfEntry.creatorBundleName, this.ntfEntry.creatorUid);
      if (result === SwitchState.SYSTEM_DEFAULT_OFF) {
        log.showInfo(`result is [SYSTEM_DEFAULT_OFF] and openSilenceDialog`)
        if (this.changeSilenceConfig) {
          this.changeSilenceConfig(this.silenceDialogFlag);
        }
      } else {
        await this.silentNtf();
      }
    } catch (e) {
      LogWithHa.warn(log, `Get silent state for ${this.ntfEntry.uid} error: ${e}`, CommonExceptionCode.GET_SILENCE_FAIL,
        e, TAG);
    } finally {
      this.ntfSettingsDialogClose = true;
    }
  };

  /**
   * 设置静默通知的值
   */
  public silentNtf = async (): Promise<void> => {
    if (!this.ntfEntry) {
      return;
    }
    log.showInfo(`silentNtf isSilent is ${this.isSilent} getGroupKey：${this.ntfEntry.getGroupKey()}`);
    ClickNotificationMaintenance.saveInfo({
      data: this.ntfEntry,
      clickRegion: true ? ClickRegion.SILENT_NTF_OFF : ClickRegion.SILENT_NTF_ON,
    });
    let isSilent = !this.isSilent;
    const result =
      await notificationConfigManager.setSilentState(this.ntfEntry.creatorUid, this.ntfEntry.creatorBundleName,
        isSilent).then((isSuccess) => {
        if (isSuccess) {
          setTimeout(() => {
            this.isSilent = isSilent;
            log.showInfo(`change isSilent to ${this.isSilent}`);
          }, 75)
        }
      });
    // 静默打点
    NotificationSysEventReporter.notificationSilence({
      CREATOR_BUNDLE_NAME: this.ntfEntry.creatorBundleName,
      IS_SILENCE_STATE_ON: isSilent ? 1 : 0,
      TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`
    });
  };

  /**
   * 查询静默状态
   * @param uid
   * @returns
   */
  public async getSilenceState(bundleName: string, uid: number): Promise<void> {
    try {
      const result = await notificationConfigManager.getSilenceState(bundleName, uid);
      this.isSilent = result;
      log.showInfo(`getSilenceState isSilent : ${this.isSilent}`);
    } catch (e) {
      LogWithHa.error(log, `Get silent state for ${uid} error: ${e}`, CommonExceptionCode.GET_SILENCE_FAIL, e, TAG);
    }
  }

  private onClickPinPop = () => {
    log.showInfo(
      `click pin top button, current Pin Top:${this.isDisplayAtTop}, uid:${this.ntfEntry?.creatorUid}`);
    let pinTop = !this.isDisplayAtTop;
    HiDfxEventUtil.reportNtfSetPinTop(pinTop ? HiSysDataOperationType.INSERT : HiSysDataOperationType
      .DELETE, this.ntfEntry?.creatorBundleName!);
    NotificationSysEventReporter.notificationPanelTop({
      OPERATE_METHOD: pinTop ? 0 : 1,
      NOTIFICATION_SLOT_TYPE: this.ntfEntry?.slotType,
      CREATOR_BUNDLE_NAME: this.ntfEntry?.creatorBundleName,
      TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`
    });
    if (this.changeAppPinTopConfig) {
      this.changeAppPinTopConfig(pinTop);
    }
    this.ntfSettingsDialogClose = true;
  }

  private onClickCancel = () => {
    log.showInfo('click cancel button: ' + this.ntfType + ', ' + this.ntfEntry?.toSimpleString());
    HiDfxEventUtil.reportNtfSetDialogClickCancel(this.ntfEntry?.creatorBundleName!, this.ntfEntry?.id!);
    NotificationSysEventReporter.notificationPanelSlipSettingCancel({
      NOTIFICATION_SLOT_TYPE: this.ntfEntry?.slotType,
      CREATOR_BUNDLE_NAME: this.ntfEntry?.creatorBundleName,
      TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      NOTIFICATION_ID: this.ntfEntry?.id
    });
    this.ntfSettingsDialogClose = true;
    // 点击取消
    NtfSettingsDC.hideDialog(this.ntfType);
  }

  private publishMetaServiceCloseEvent(): void {
    if (this.ntfEntry && this.ntfEntry.liveViewData) {
      log.showInfo(`publishData: bundleName: ${this.ntfEntry.creatorBundleName},
        localId: ${this.ntfEntry.creatorUserId}, event: ${this.ntfEntry.liveViewData.event}`);
      let publishData: CommonEventManager.CommonEventPublishData = {
        code: 1, // 元服务实况窗开关关闭事件
        subscriberPermissions: ['ohos.permission.NOTIFICATION_AGENT_CONTROLLER'],
        parameters: {
          'bundleName': this.ntfEntry.creatorBundleName,
          'localId': this.ntfEntry.creatorUserId,
          'event': this.ntfEntry.liveViewData.event ? [this.ntfEntry.liveViewData.event] : [],
          'enabled': false
        }
      }
      CommonEventManager.publishAsUser('sceneboard.event.PUSH_AGENT', ZERO_USER_ID, publishData, (err: base.BusinessError) => {
        if (err) {
          log.showInfo(`publish MetaServiceCloseEvent for allUser failed, code: ${err.code}, message: ${err.message}`);
        } else {
          log.showInfo(`publish MetaServiceCloseEvent for allUser success`);
        }
      })
    }
  }

  /**
   * 点击更多设置按钮
   */
  clickMoreSetting(): void {
    let bundleName = this.getBundleName();
    HiDfxEventUtil.reportNtfMenuClickMoreSetting(this.ntfEntry?.creatorBundleName!, this.ntfEntry?.id!);
    NotificationSysEventReporter.notificationPanelSlipSettingMore({
      NOTIFICATION_SLOT_TYPE: this.ntfEntry?.slotType,
      CREATOR_BUNDLE_NAME: this.ntfEntry?.creatorBundleName,
      TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      NOTIFICATION_ID: this.ntfEntry?.id,
      BUNDLE_TYPE: this.ntfEntry?.bundleType,
      TRACE_ID: this.ntfEntry?.traceId,
    });
    log.showInfo('clickMoreSetting ntfType: ' + this.ntfType + ', bundleName: ' + bundleName);
    this.openAppByNtfType(bundleName, this.handleMoreSettingClick);
  }

  getBundleName(): string {
    if (CommonUtils.isInvalid(this.ntfEntry)) {
      log.showError('getBundleName ntfEntry is invalid');
      return '';
    }
    log.showInfo('getBundleName ntfEntry: ' + this.ntfEntry?.toSimpleString());
    return this.ntfEntry?.creatorBundleName!;
  }

  /**
   * 无障碍下点击弹框置顶条目切换通知置顶状态时，播报的反馈文本
   * @param pinTop 点击后通知的置顶状态
   * @returns
   */
  private getPinTopStateChangeAccessibilityText(pinTop: boolean): string {
    if (pinTop) {
      return ResUtils.getInnerStringNumS($r('app.string.nc_accessibility_pinned_notification'));
    } else {
      return ResUtils.getInnerStringNumS($r('app.string.nc_accessibility_unpinned_notification'));
    }
  }

  /**
   * 跳转通知管理界面
   */
  handleMoreSettingClick = (bundleName: string): void => {
    log.showInfo('handleMoreSettingClick bundleName: ' + bundleName + ' uid: ' + this.ntfEntry?.creatorUid);
    let listContentConfig = ntfViewConfigManager.getListContentConfig();
    // 元服务跳转B2C详情页，tv元服务和应用使用同一个页面
    if (this.isMetaService() && !listContentConfig.isMetaSettingSamePage) {
      ntfMgr.startMetaServiceItemAbility(bundleName, this.ntfEntry?.appIndex, this.ntfEntry?.creatorUid);
      return;
    }
    // 跳转页面
    ntfMgr.startNtfMgrItemAbility(bundleName, listContentConfig.moreSettingModuleName, this.ntfEntry?.appIndex,
      listContentConfig.moreSettingUri, this.ntfEntry?.creatorUid);
  }

  private openAppByNtfType = (bundleName: string, callBack: (bundleName: string) => void) => {
    if (NotificationType.isKeyguard(this.ntfType)) {
      ScreenLockApi.requestUnlock({
        success: () => {
          callBack(bundleName);
        }
      });
      NtfSettingsDC.hideDialog(this.ntfType);
    } else {
      NtfSettingsDC.hideDialog(this.ntfType);
      // 收起面板
      NotificationPanelManager.collapseNtfPanel(this.ntfType, true);
      // 延迟跳转
      setTimeout(() => {
        callBack(bundleName);
      }, DropDownPanelConstants.NOTIFICATION_TIME_VIEW_HIDE_DURATION);
    }
  }

  private onClickOpenAppNtfMgmt = () => {
    const bundleName = this.getBundleName();
    NotificationSysEventReporter.notificationOpenAppInnerMgmt({
      NOTIFICATION_SLOT_TYPE: this.ntfEntry?.slotType,
      CREATOR_BUNDLE_NAME: this.ntfEntry?.creatorBundleName,
      TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      NOTIFICATION_ID: this.ntfEntry?.id,
      NOTIFICATION_TYPE: this.ntfType,
    });
    log.showInfo(`Open app notification management: ${this.ntfType}, ${this.ntfEntry?.toSimpleString()}`);
    this.ntfSettingsDialogClose = true;
    this.openAppByNtfType(bundleName, this.openAppNtfMgmt);
  }

  private openAppNtfMgmt = (bundleName: string) => {
    if (this.ntfEntry) {
      NotificationApiUtil.openAppNtfMgmt(bundleName, this.appNtfMgmtAbilityName ?? '', this.ntfEntry.appIndex);
    }
  }
}