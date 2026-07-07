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
import { LiveCardOtherModel, NotificationBase, NotificationDataManager } from '@ohos/systemuicommon/newTsIndex';
import {
  AnimationBase,
  INotificationPinTopLimitDialogVm,
  INotificationSettingDialogVm,
  NotificationBaseVm,
  NotificationSettingDialogModel,
  NotificationSettingMenu,
  NotificationSettingMenuType,
  DropdownVm,
  DropDownPanelManager,
  StartAppOneMirrorAnimation,
  LiveNotification,
} from '@ohos/systemuicommon/newIndex';
import { NotificationConstants } from '../common/NotificationConstants';
import { NotificationApiUtil } from '../utils/NotificationApiUtil';
import {
  ClickNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { NotificationCardVm } from './NotificationCardVm';
import { curves } from '@kit.ArkUI';
import { LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { AccessibilityVm } from '@ohos/systemuicommon/src/main/ets/vm/AccessibilityVm';
import { bundleManager } from '@kit.AbilityKit';
import { DropdownCallback, NotificationType } from '@ohos/systemuicommon/Index';
import { NotificationSysEventReporter, SystemUICommonUtil } from '@ohos/systemuicommon';
import { CommonExceptionCode } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionCode';
import {
  INotificationSilenceVm
} from '@ohos/systemuicommon/src/main/ets/notification/interface/INotificationSilenceVm';
import { LogWithHa } from '@ohos/systemuicommon';
import { NtfSettingManagerUtils, SwitchState } from '@ohos/systemuicommon/newTsIndex';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { ExtAppConstants } from '@ohos/commonconstants';
import CommonEventManager from '@ohos.commonEventManager';
import base from '@ohos.base';

const TAG = 'NotificationSettingDialogVm';
const log: Logger = Logger.getLogHelper(LogDomain.NC);
const AIMATION_CURVE = curves.cubicBezierCurve(0.33, 0, 0.67, 1);
const MORE_SETTING_URI = 'systemui_notification_settings';
const NOTIFICATION_TIME_VIEW_HIDE_DURATION: number = 400;
const NTF_SETTING_DIALOG_MENU_ID: string = 'NotificationSettingDialogView';

@ObservedV2
export class NotificationSettingDialogVm extends NotificationBaseVm implements INotificationSettingDialogVm {
  /**
   * 设置弹窗数据
   */
  @Trace public settingDiagData = new NotificationSettingDialogModel();
  public componentId: string = NTF_SETTING_DIALOG_MENU_ID;
  public showHideButton: boolean = true;
  private pinTopDialogVm: INotificationPinTopLimitDialogVm = this.vmInjector.getPinTopDialogVm();
  private silenceVm: INotificationSilenceVm = this.vmInjector.getSilenceVm();
  public ntf?: NotificationBase;
  private anim: AnimationBase = new AnimationBase(AnimationBase.NAMES.NTF_DIALOG_ANIMATION, true);
  private dropdownVm = DropdownVm.instance;
  // 应用内通知管理AbilityName
  private appNtfMgmtAbilityName?:string;
  private isSilent = false;
  private silenceDialogFlag = false;
  private dropdownCallback: DropdownCallback = {
    tag: TAG,
    isNC: true,
    onBackPress: (): boolean => {
      if (this.settingDiagData.isShowDialog) {
        this.hide();
        return true;
      }
      if (this.pinTopDialogVm.isShow) {
        this.pinTopDialogVm.onCancel();
        return true;
      }
      if (this.silenceVm.isShowFlag) {
        this.silenceVm.onCancel();
        return true;
      }
      return false;
    },
    onHide: (): void => {
      if (this.pinTopDialogVm.isShow) {
        this.pinTopDialogVm.onCancel();
      }
      if (this.silenceVm.isShowFlag) {
        this.silenceVm.onCancel();
      }
    },
    onDropdown: (): boolean => {
      if (this.pinTopDialogVm.isShow) {
        return true;
      }
      if (this.silenceVm.isSilenceDialogShow) {
        return true;
      }
      return false;
    }
  };

  init(): void {
    DropDownPanelManager.registerCallback(this.dropdownCallback);
  }

  unInit(): void {
    DropDownPanelManager.unregisterCallback(this.dropdownCallback);
  }

  @Monitor('settingDiagData.isShowDialog')
  onNtfSettingsDialogCloseChange() {
    log.showInfo(TAG, `settingDialogData isShowDialog change: ${this.settingDiagData.isShowDialog}`);
    this.dropdownVm.ntfSettingsDialogClose = !this.settingDiagData.isShowDialog;
    }

  public async openSetting(ntf: NotificationBase, buttonPosition: Position): Promise<void> {
    log.showInfo(TAG, `open dialog, ntf: ${ntf?.hashCode}`);
    if (!ntf) {
      return;
    }
    this.ntf = ntf;
    if (this.ntf) {
      await this.getSilenceState(this.ntf.creatorBundleName, this.ntf.creatorUid);
    }
    this.silenceVm.ntf = this.ntf;
    this.dropdownVm.ntfSettingsDialogClose = false;
    NotificationApiUtil.setStatusBarZIndex('update');
    this.ntf = ntf;
    this.appNtfMgmtAbilityName = NotificationApiUtil.getAppNtfMgmtAbilityName(this.ntf?.creatorBundleName);
    this.updateSettingDiagData(buttonPosition);
    this.vmInjector.getMenuVm(this.ntf)!.settingButtonData.opacity = 0;
    this.anim.executeAnimation([{
      duration: 350,
      curve: AIMATION_CURVE,
      event: () => this.vmInjector.getPanelVm()!.scale = 0.97,
    }])
  }

  /**
   * 隐藏显示通知设置弹窗
   */
  public hide(): void {
    NotificationApiUtil.setStatusBarZIndex('reset');
    this.settingDiagData.isShowDialog = false;
    this.anim.executeAnimation([{
      duration: 100,
      curve: AIMATION_CURVE,
      event: () => this.vmInjector.getPanelVm()!.scale = 1,
    }]).then(() => {
      if (!this.settingDiagData.isShowDialog) {
        this.settingDiagData.isShowButton = false;
      }
      if (this.ntf) {
        this.vmInjector.getMenuVm(this.ntf)!.settingButtonData.opacity = 1;
      }
    });
  }

  private updateSettingDiagData(buttonPosition: Position): void {
    this.settingDiagData.buttonPositionLeft = buttonPosition.x as number;
    this.settingDiagData.buttonPositionTop = buttonPosition.y as number;
    this.setDialogTitle();
    this.updateMenus();
    this.settingDiagData.isShowDialog = this.settingDiagData.menus.length > 0;
    this.settingDiagData.isShowButton = this.settingDiagData.isShowDialog;
  }

  public setDialogTitle(): void {
    this.settingDiagData.dialogTitle = this.getDialogTitle();
  }

  /**
   * 弹框标题
   * @returns
   */
  private getDialogTitle(): string {
    if (this.isUnstallMetaServiceLive()) {
      // 未安装元服务实况包名
      log.showInfo(TAG, `unstall meta service live boundname ${this.ntf?.unstallMetaSerBoundName}`);
      return ResUtils.getInnerStringNumS($r('app.string.live_view_setting_dialog_title'), this.ntf?.unstallMetaSerBoundName);
    }
    return ResUtils.getInnerStringNumS(
      this.ntf?.isLiveView() && !this.ntf?.isConvertFromNormal ? $r('app.string.live_view_setting_dialog_title') :
      $r('app.string.ntf_setting_dialog_title'),
      this.ntf?.appLabel);
  }

  /**
   * 更新菜单项
   */
  private updateMenus(): void {
    if (!this.ntf) {
      return;
    }

    this.settingDiagData.menus.splice(0, this.settingDiagData.menus.length);
    if (this.ntf.isLiveView()) {
      if (this.isUnstallMetaServiceLive()) {
        this.settingDiagData.menus.push(this.getUnstallMetaServiceLiveCloseMenu())
      } else{
        if (this.isAtomicServiceFromPush()) {
          this.settingDiagData.menus.push(this.getMetaServiceLiveViewCloseMenu());
        } else {
          this.settingDiagData.menus.push(this.getAppLiveViewCloseMenu());
        }
      }
    } else {
      if (this.appNtfMgmtAbilityName) {
        this.settingDiagData.menus.push(this.getAppNtfMgmtMenu());
      }
      if (this.isShowCloseButton()) {
        if (this.isMetaService()) {
          this.settingDiagData.menus.push(this.getMetaServiceCloseMenu());
        } else {
          this.settingDiagData.menus.push(this.getNotificationCloseMenu());
        }
      }
      if (this.ntf?.bundleType === bundleManager.BundleType.APP){
        this.settingDiagData.menus.push(this.getNotificationSilenceMenu());
      }
      if (this.isShowPintTopButton()) {
        this.settingDiagData.menus.push(this.getNotificationPinTopMenu());
      }
      if (this.isShowSettingButton()) {
        this.settingDiagData.menus.push(this.getNotificationOpenSettingMenu());
      }
    }
  }

  private isAtomicServiceFromPush(): boolean {
    if (this.ntf?.isLiveView() && this.ntf.isAtomicServiceFromPush) {
      return true;
    }
    return false;
  }

  private isShowCloseButton(): boolean {
    if (!this.ntf) {
      return false;
    }
    // 在不允许关闭通知白名单（关闭按钮、更多设置均不显示）或者 屏蔽"关闭此应用通知"按钮白名单（只有关闭按钮不显示）里面关闭通知按钮不显示
    if (NotificationConstants.DISABLE_CLOSE_NOTIFICATION_PACKAGE_NAME.includes(this.ntf.creatorBundleName) ||
      NotificationConstants.DISABLE_CLOSE_BUTTON_PACKAGE_NAME.has(this.ntf.creatorBundleName)) {
      return false;
    }
    return true;
  }

  private isShowPintTopButton(): boolean {
    if (this.ntf?.isDeliverNotification || this.isMetaService()) {
      return false;
    }
    return true;
  }

  private isShowSettingButton(): boolean {
    if (!this.ntf) {
      return false;
    }
    if (NotificationConstants.DISABLE_CLOSE_NOTIFICATION_PACKAGE_NAME.includes(this.ntf.creatorBundleName) ||
    this.ntf.isSettingIgnore) {
      return false;
    }
    return true;
  }

  /**
   * 是否push发送的元服务通知
   */
  private isMetaService(): boolean {
    return Boolean(this.ntf?.isFromPush && this.ntf?.bundleType === bundleManager.BundleType.ATOMIC_SERVICE);
  }

  /**
   * 是否是未安装的元服务实况
   */
  private isUnstallMetaServiceLive(): boolean {
    return Boolean(!this.ntf?.isInstallMetaSer);
  }

  /**
   * 打开应用内通知管理的菜单
   */
  private getAppNtfMgmtMenu(): NotificationSettingMenu {
    return new NotificationSettingMenu(
      NotificationSettingMenuType.OPEN_APP_NTF_MGMT,
      ResUtils.getInnerStringNumS($r('app.string.open_app_inner_ntf_mgmt'), this.ntf?.appLabel ?? ''),
      this.openAppInnerNtfMgmt,
    );
  }

  /**
   * 关闭元服务的实况通知开关的菜单
   */
  private getMetaServiceLiveViewCloseMenu(): NotificationSettingMenu {
    return new NotificationSettingMenu(
      NotificationSettingMenuType.CLOSE,
      $r('app.string.ntf_close_meta_service_live_view_notification'),
      this.closeMetaNtf,
    );
  }

  /**
   * 关闭应用的实况通知开关的菜单
   */
  private getAppLiveViewCloseMenu(): NotificationSettingMenu {
    return new NotificationSettingMenu(
      NotificationSettingMenuType.CLOSE,
      $r('app.string.ntf_close_pkg_live_view'),
      this.closeNtf,
    );
  }

  /**
   * 关闭普通通知开关的菜单
   */
  private getNotificationCloseMenu(): NotificationSettingMenu {
    return new NotificationSettingMenu(
      NotificationSettingMenuType.CLOSE,
      $r('app.string.ntf_close_pkg_notification'),
      this.closeNtf,
    );
  }

  /**
   * 关闭元服务通知开关的菜单
   */
  private getMetaServiceCloseMenu(): NotificationSettingMenu {
    return new NotificationSettingMenu(
      NotificationSettingMenuType.CLOSE,
      $r('app.string.ntf_close_meta_service_notification'),
      this.closeMetaService,
    );
  }

  /**
   * 关闭未安装元服务实况开关的菜单
   */
  private getUnstallMetaServiceLiveCloseMenu(): NotificationSettingMenu {
    return new NotificationSettingMenu(
      NotificationSettingMenuType.CLOSE,
      $r('app.string.ntf_close_meta_service_live_view_notification'),
      this.closeUnstallMetaServiceLive,
    );
  }

  /**
   * 置顶通知的菜单
   */
  private getNotificationPinTopMenu(): NotificationSettingMenu {
    return new NotificationSettingMenu(
      NotificationSettingMenuType.PIN_TOP,
      this.ntf?.isDisplayAtTop ? $r('app.string.ntf_cancel_pin_top_pkg_notification') : $r('app.string.ntf_pin_top_pkg_notification'),
      this.pinPopNtf,
    );
  }

  /**
   * 静默通知的菜单
   */
  private getNotificationSilenceMenu(): NotificationSettingMenu {
    return new NotificationSettingMenu(
      NotificationSettingMenuType.SILENCE,
      this.isSilent ? $r('app.string.disable_silent_notifications') : $r('app.string.silence_app_notifications'),
      this.onSilenceClick,
    );
  }

  /**
   * 打开通知设置的菜单
   */
  private getNotificationOpenSettingMenu(): NotificationSettingMenu {
    return new NotificationSettingMenu(
      NotificationSettingMenuType.OPEN_SETTING,
      $r('app.string.ntf_dialog_more_settings'),
      this.openMoreSetting,
    );
  }

  /**
   * 关闭元服务实况通知开关
   */
  private closeMetaNtf = (): void => {
    if (!this.ntf) {
      return;
    }
    log.showInfo(TAG, 'Close meta service live view switch: ' + this.ntf.groupKey);
    NotificationApiUtil.setLiveViewEnable(this.ntf.creatorBundleName, this.ntf.creatorUid, false);
    this.publishMetaServiceCloseEvent();
    this.hide();
  };

  private publishMetaServiceCloseEvent(): void {
    if (!this.ntf || !(this.ntf instanceof LiveNotification)) {
      return;
    }
    if (!this.ntf.card || !(this.ntf.card instanceof LiveCardOtherModel)) {
      return;
    }
    log.showInfo(TAG, `publishData: bundleName: ${this.ntf.creatorBundleName},
        localId: ${this.ntf.creatorUserId}, event: ${this.ntf.card.event}`);
    let publishData: CommonEventManager.CommonEventPublishData = {
      code: 1, // 元服务实况窗开关关闭事件
      subscriberPermissions: ['ohos.permission.NOTIFICATION_AGENT_CONTROLLER'],
      parameters: {
        'bundleName': this.ntf.creatorBundleName,
        'localId': this.ntf.creatorUserId,
        'event': this.ntf.card.event ? [this.ntf.card.event] : [],
        'enabled': false
      }
    }
    CommonEventManager.publishAsUser('sceneboard.event.PUSH_AGENT', 0, publishData, (err: base.BusinessError) => {
      if (err) {
        log.showInfo(TAG,
          `publish MetaServiceCloseEvent for allUser failed, code: ${err.code}, message: ${err.message}`);
      } else {
        log.showInfo(TAG, `publish MetaServiceCloseEvent for allUser success`);
      }
    })
  }

  /**
   * 关闭元服务通知开关
   */
  private closeMetaService = (): void => {
    if (!this.ntf) {
      return;
    }
    log.showInfo(TAG, 'Close meta service notification switch: ' + this.ntf.groupKey);
    ClickNotificationMaintenance.saveInfo({
      data: this.ntf,
      clickRegion: ClickRegion.CLOSE_META_SERVICE_NTF_ENABLE,
    });

    const accessibilityRes = this.ntf.isLiveView() ?
    $r('app.string.nc_accessibility_close_live_view') :
    $r('app.string.nc_accessibility_close_notification');
    AccessibilityVm.instance.sendEventByResource(accessibilityRes);

    NotificationApiUtil.setMetaServiceNotificationEnable(this.ntf.creatorBundleName, this.ntf.creatorUid, false);
    this.hide();
  };

  /**
   * 关闭未安装元服务实况开关
   */
  private closeUnstallMetaServiceLive = (): void => {
    if (!this.ntf) {
      return;
    }
    log.showInfo(TAG, 'Close unstall meta service live switch: ' + this.ntf.groupKey);
    ClickNotificationMaintenance.saveInfo({
      data: this.ntf,
      clickRegion: ClickRegion.CLOSE_UNSTALL_META_SERVICE_LIVE_ENABLE,
    });
    NotificationApiUtil.setUnstallMetaServiceLiveEnable(this.ntf.creatorBundleName, this.ntf.creatorUid, false);
    this.publishMetaServiceCloseEvent();
    NotificationDataManager.instance.removeLiveView([this.ntf]);
    this.hide();
  };

  /**
   * 关闭通知开关
   */
  private closeNtf = (): void => {
    if (!this.ntf) {
      return;
    }
    log.showInfo(TAG, 'Close notification switch: ' + this.ntf.groupKey);
    ClickNotificationMaintenance.saveInfo({
      data: this.ntf,
      clickRegion: this.ntf.isLiveView() ? ClickRegion.CLOSE_LIVE_VIEW_ENABLE : ClickRegion.CLOSE_NTF_ENABLE,
    });
    NotificationApiUtil.closeSwitch(this.ntf);
    // 关闭此应用通知打点
    NotificationSysEventReporter.notificationPanelSlipSettingClose({
      NOTIFICATION_SLOT_TYPE: this.ntf?.slotType,
      CREATOR_BUNDLE_NAME: this.ntf?.creatorBundleName,
      TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      NOTIFICATION_ID: this.ntf?.id,
      BUNDLE_TYPE: this.ntf?.bundleType,
      TRACE_ID: this.ntf?.traceId
    });

    const accessibilityRes = this.ntf.isLiveView() ?
    $r('app.string.nc_accessibility_close_live_view') :
    $r('app.string.nc_accessibility_close_notification');
    AccessibilityVm.instance.sendEventByResource(accessibilityRes);
    AccessibilityVm.instance
      .requestFocusAccessibility(this.vmInjector.getSwipeVm(this.ntf)?.getRemoveAccessibilityId(this.ntf) ?? '', true);

    this.hide();
  };

  private onSilenceClick = async (): Promise<void> => {
    if (!this.ntf) {
      return;
    }
    this.silenceDialogFlag = true;
    try {
      const result =
        await NtfSettingManagerUtils.isSilentReminderEnabled(this.ntf.creatorBundleName, this.ntf.creatorUid);
      if (result === SwitchState.SYSTEM_DEFAULT_OFF ) {
        this.silenceVm.ntf = this.ntf;
        this.silenceVm.openSilenceDialog();
      } else {
        await this.silentNtf();
      }
    } catch (e) {
      LogWithHa.showWarn(Logger.getLogHelper(LogDomain.NC), TAG, `Get silent state for ${this.ntf.uid} error: ${e}`, CommonExceptionCode.GET_SILENCE_FAIL, e);
    }
  };

  /**
   * 静默通知
   */
  public silentNtf = async (): Promise<void> => {
    if (!this.ntf) {
      return;
    }
    log.showInfo(TAG, `Silence: ${this.ntf.groupKey}`);
    this.isSilent = !this.isSilent;
    ClickNotificationMaintenance.saveInfo({
      data: this.ntf,
      clickRegion: true ? ClickRegion.SILENT_NTF_OFF : ClickRegion.SILENT_NTF_ON,
    });
    const isSuccess = await this.silenceVm.setSilence(this.ntf, this.isSilent);
    log.showInfo(TAG, `Silence isSuccess: ${isSuccess}`);
  };

  /**
   * 置顶通知
   */
  private pinPopNtf = async (): Promise<void> => {
    if (!this.ntf) {
      return;
    }
    log.showInfo(TAG, `Pin Top: ${this.ntf.groupKey}`);
    let pinTop = !this.ntf?.isDisplayAtTop;
    ClickNotificationMaintenance.saveInfo({
      data: this.ntf,
      clickRegion: this.ntf?.isDisplayAtTop ? ClickRegion.PIN_TOP_OFF : ClickRegion.PIN_TOP_ON,
    });
    this.updateCardAnim();
    const isSuccess = await this.pinTopDialogVm.setPinTop(this.ntf.creatorUid, this.ntf?.isDisplayAtTop ? false : true);
    // 置顶打点
    NotificationSysEventReporter.notificationPanelTop({
      OPERATE_METHOD: pinTop ? 0 : 1,
      NOTIFICATION_SLOT_TYPE: this.ntf?.slotType,
      CREATOR_BUNDLE_NAME: this.ntf?.creatorBundleName,
      TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`
    });
    log.showInfo(TAG, `Pin Top isSuccess: ${isSuccess}`);
    if (isSuccess) {
      AccessibilityVm.instance.sendEventByResource(this.getPinTopStateChangeAccessibilityText(pinTop));
    }
    this.hide();
  };

  private updateCardAnim(): void {
    const moreNtfList = this.vmInjector.getListVm()!.moreNtfList;
    for (const ntf of moreNtfList) {
      this.vmInjector.getCardVm(ntf).updateTransitionAnimation(NotificationCardVm.cardAnim);
    }
  }

  /**
   * 无障碍下点击弹框置顶条目切换通知置顶状态时，播报的反馈文本
   * @param pinTop 点击后通知的置顶状态
   * @returns
   */
  private getPinTopStateChangeAccessibilityText(pinTop: boolean): Resource {
    if (pinTop) {
      return $r('app.string.nc_accessibility_pinned_notification');
    } else {
      return $r('app.string.nc_accessibility_unpinned_notification');
    }
  }

  /**
   * 打开更多通知设置
   */
  private openMoreSetting = () => {
    this.openNtfSetting();
    // 点击更多设置打点
    NotificationSysEventReporter.notificationPanelSlipSettingMore({
      NOTIFICATION_SLOT_TYPE: this.ntf?.slotType,
      CREATOR_BUNDLE_NAME: this.ntf?.creatorBundleName,
      TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      NOTIFICATION_ID: this.ntf?.id,
      BUNDLE_TYPE: this.ntf?.bundleType,
      TRACE_ID: this.ntf?.traceId,
    });
  };

  /**
   * 打开应用内通知管理
   */
  private openAppInnerNtfMgmt = () => {
    this.openAppNtfMgmt();
  };

  /**
   * 打开通知设置 提取函数供子类重写
   */
  protected openNtfSetting(): void {
    if (!this.ntf) {
      log.showError(TAG, 'openNtfSetting failed, invalid ntf');
      return;
    }
    log.showInfo(TAG, 'Open more setting: ' + this.ntf.groupKey);

    // 设置一镜到底动效
    let cardRect =
      SystemUICommonUtil.getRect(this.componentId, ArkUIAdapter.getUiContextByViewName(this.vmInjector.viewName));
    DropdownVm.instance.oneMirrorAnimating = true;
    NotificationApiUtil.setRotateEnabled(true);
    StartAppOneMirrorAnimation.instance.prepare({
      scene: this.vmInjector.scene,
      cardRect: cardRect,
      cardRadius: 20,
      bundleName: ExtAppConstants.PKG_SETTINGS,
      onExecute: () => {
        // 动效抵达全屏，快结束的时候收起通知中心面板。过早会漏出通知中心面板下面的内容，过晚会闪现通知中心
        setTimeout(() => {
          DropdownVm.instance.hidePanel(false);
        }, 370);
      }
    }).then(() => {
      DropdownVm.instance.hidePanel(false);
      DropdownVm.instance.oneMirrorAnimating = false;
    });

    // 拉起通知管理页面
    const bundleName = this.ntf.creatorBundleName;
    log.showInfo(TAG, `handleMoreSettingClick bundleName: ${bundleName}, isMetaService: ${this.isMetaService()}`);
    // 跳转设置页面，使用ApiUtil中的方法，可以处理跨线程调用场景
    NotificationApiUtil.openNtfSetting(bundleName, this.ntf.appIndex, MORE_SETTING_URI, this.ntf.creatorUid,
      this.isMetaService());
  };

  /**
   * 打开应用内通知管理 提取函数供子类重写
   */
  protected openAppNtfMgmt(): void {
    log.showInfo(TAG, `Open app notification management: ${this.ntf?.groupKey}`);
    NotificationSysEventReporter.notificationOpenAppInnerMgmt({
      NOTIFICATION_SLOT_TYPE: this.ntf?.slotType,
      CREATOR_BUNDLE_NAME: this.ntf?.creatorBundleName,
      TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      NOTIFICATION_ID: this.ntf?.id,
      NOTIFICATION_TYPE: this.getNotificationType(),
    });
    // 延迟跳转
    setTimeout(() => {
      if (this.ntf) {
        NotificationApiUtil.openAppNtfMgmt(this.ntf.creatorBundleName, this.appNtfMgmtAbilityName ?? '',
          this.ntf.appIndex);
      }
    }, NOTIFICATION_TIME_VIEW_HIDE_DURATION);
    this.hide();
    DropdownVm.instance.hidePanel(true);
  };

  protected getNotificationType(): number {
    return NotificationType.TYPE_PHONE_DROPDOWN;
  }

  /**
   * 查询静默状态
   * @param uid
   * @returns
   */
  public async getSilenceState(bundleName: string, uid: number): Promise<void> {
    try {
      const result = await NtfSettingManagerUtils.isSilentReminderEnabled(bundleName, uid);
      this.isSilent = result === SwitchState.USER_MODIFIED_ON;
    } catch (e) {
      LogWithHa.showError(Logger.getLogHelper(LogDomain.NC), TAG, `Get silent state for ${uid} error: ${e}`, CommonExceptionCode.GET_SILENCE_FAIL, e);
    }
  }

  public getStatusBarReset() {
    this.silenceDialogFlag = false;
    NotificationApiUtil.setStatusBarZIndex('reset');
  }
}