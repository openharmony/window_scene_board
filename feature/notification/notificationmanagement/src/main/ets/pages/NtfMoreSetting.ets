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
import HeadComponent from '@ohos/managementcomponent/src/main/ets/com/ohos/view/component/headComponent';
import ConfigData from '../common/constants';
import { LogDomain, LogHelper, LogWithHa,
  NotificationConfigEvent } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { NtfSettingSysEventReporter }
  from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';
import { SystemParameterUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/SystemParameterUtil';
import enableComponent from '@ohos/managementcomponent/src/main/ets/com/ohos/view/component/enableComponent';
import osAccount from '@ohos.account.osAccount';
import NtfSettingUtil from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingUtil';
import NtfMgmtSwitchItemsComponent from './NftMgmtSwitchItemsComponent';
import { DeviceHelper, sSettingsUtil } from '@ohos/managementcomponent';
import {
  FingerprintType,
  SettingsConstants,
  SettingsKeyConstants
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import { BusinessError } from '@kit.BasicServicesKit';
import userIAM_userAuth from '@ohos.userIAM.userAuth';
import { LengthMetrics } from '@ohos.arkui.node';
import { PageStorages } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/PageStorages';
import { StatusBarModel } from '../model/StatusBarModel';
import { ResourceUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/ResourceUtil';
import NftBadgeSwitchItemsComponent from './NftBadgeSwitchItemsComponent';
import { HdsNavDestination, HdsNavDestinationAttribute } from '@kit.UIDesignKit';
import { SysUIHdsNavigations } from '../common/SysUIHdsNavigations';
import NtfDisplayContentSelectComponent from './NtfDisplayContentSelectComponent';
import NtfDisplayLiveWindowContent from './NtfDisplayLiveWindowContent';
import NotificationDistributeComponent from './NotificationDistributeComponent';
import { SettingExceptionCode } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/SettingExceptionCode';
import {
  getDistributedDeviceList
} from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubNotificationDistribution';
import {
  notificationSettingManager
} from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/NotificationSettingManager';
import { AccessibilityManager } from '../common/AccessibilityManager';

const TAG = 'NtfMoreSetting';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const lockLabelName: Resource = $r('app.string.lock_screen_notification');
/* 隐藏横幅通知内容设置的key */
const APP_NTF_CONFIG_HIDE_BANNER_CONTENT: string = 'app_ntf_config_hide_banner_content';
/* 默认关闭隐藏横幅通知内容开关 等于1为默认开启*/
const BANNER_NTF_HIDE_CONTENT: string = '0';
/* 全场景开关条目出现事件的key */
const NTF_DISTRIBUTION_BUTTON_EVENT = 'notification.event.DISTRIBUTED_DEVICE_TYPES_CHANGE';

export interface UserAuthRequest {
  authType: osAccount.AuthType,
  keys: osAccount.GetPropertyType[],
}

const FINGER_ERROR_CODE: number = 12500005;

export class FaceUnlockConstants {
  /**
   * The key to get whether faceUnlock is enable.
   */
  public static readonly KEY_FACE_KEYGUARD_ENABLE: string = 'face_bind_with_lock';
  /**
   * is enabled
   */
  public static readonly FACE_SWITCH_ENABLE: string = '1';
}

@Entry
@Component
export struct NtfMoreSetting {
  private scroller: Scroller = new Scroller();

  /**
   * 初始化设置中智能提醒下描述的内容，根据是否支持轻提醒变更
   */
  @State smartReminderTips : ResourceStr = '';

  /**
   * 是否从通知和状态栏页面进入，为false的场景是从设置搜索直接跳转
   */
  private isFromHome: boolean = true;
  private headName: Resource = $r('app.string.more_ntf_setting');
  ntfSettingUtil: NtfSettingUtil = new NtfSettingUtil();
  @State hideBackButton: boolean = false;

  /**
   * 锁屏通知样式列表态
   */
  @State initUpperState: boolean = true;

  /**
   * 锁屏通知样式收纳态
   */
  @State initLowerState: boolean = false;
  @State isLowPosFingerPrint: boolean = false;
  @StorageLink('isLandscape') isLandscape: boolean = false;
  @StorageLink('navigationMode')
  @Watch('onNavModeChanged') navMode: number = AppStorage.get('navigationMode') ?? -1;

  /**
   * 是否隐藏横幅通知内容
   */
  @State hasFaceData: boolean = false;
  @State isFaceOpen: number = 1;
  @State isSupportSmartNtf: boolean = false;
  @State isHiddenContent: number = 0;
  @State isShow: boolean = false;
  @State statusBarModel: StatusBarModel = StatusBarModel.get();
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @State transitionType: NavigationSystemTransitionType = NavigationSystemTransitionType.DEFAULT;

  /**
   * 是否已在初始化时设置过 isShowLearnMore 的值
   */
  private hasSetShowLearnMoreVal: boolean = false;

  /**
   * 是否展示协同开关
   */
  @State isDistributionSetBefore: boolean = false;

  /**
   * 是否订阅了协同事件
   */
  private isSubscribed = false;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    this.isFromHome = PageStorages.getPageContext()?.isFromHome ?? true;
    if (!this.isFromHome) {
      this.navMode = this.ntfSettingUtil.navModeInit();
    }
    this.hideBackButton = this.navMode === NavigationMode.Split;
    this.hasDistributionSet().then(result => {
      this.isDistributionSetBefore = result;
      if (!result) {
        notificationSettingManager.subscribeDistributionChangeEvent(this.onDistributionButtonChange);
        this.isSubscribed = true;
      }
    });
    this.isLowPosFingerPrintInit();
    this.setDestinationEntryType();
  }

  aboutToDisappear(): void {
    log.showInfo(`NtfMoreSetting aboutToDisappear`);
    if (this.isSubscribed) {
      notificationSettingManager.unsubscribeChangeEvent(this.onDistributionButtonChange);
    }
  }

  async initHideBannerContent(): Promise<void> {
    try {
      this.isSupportSmartNtf = await SystemParameterUtil.isSupportSmartNtf();
      this.hasFaceData = await this.isFaceEnrolled();
      this.isFaceOpen =
        Number(sSettingsUtil.getSecureValue(FaceUnlockConstants.KEY_FACE_KEYGUARD_ENABLE,
          FaceUnlockConstants.FACE_SWITCH_ENABLE));
      this.isHiddenContent =
        Number(sSettingsUtil.getSecureValue(APP_NTF_CONFIG_HIDE_BANNER_CONTENT,
          BANNER_NTF_HIDE_CONTENT));
      log.showInfo(`initHideBannerContent hasFaceData is ${this.hasFaceData} isFaceOpen is ${this.isFaceOpen} isSupportSmartNtf is${this.isSupportSmartNtf}`);
    } catch (err) {
      log.showError(`getSync unexpected error code:` + err?.code + ', message:' + err?.message);
    }
  }

  async isFaceEnrolled(): Promise<boolean> {
    let credentials: osAccount.EnrolledCredInfo[] =
      await new osAccount.UserIdentityManager().getAuthInfo(osAccount.AuthType.FACE);
    return credentials.length > 0;
  }

  private isSupportFingerPrint(): boolean {
    try {
      userIAM_userAuth.getAvailableStatus(userIAM_userAuth.UserAuthType.FINGERPRINT,
        userIAM_userAuth.AuthTrustLevel.ATL4);
    } catch (error) {
      let message = (error as BusinessError)?.message
      let code = (error as BusinessError)?.code
      log.showInfo(`isSupportFingerPrint failed errorCode: ${code}, message: ${message}`);
      if (code === FINGER_ERROR_CODE) { // 人脸指纹失败
        return false;
      }
    }
    return true;
  }

  async isLowPosFingerPrintInit() : Promise<void> {
    if (!this.isSupportFingerPrint()) {
      this.ntfScreenLockUpperStyleInit();
      return;
    }
    const fingerprintType = Number(sSettingsUtil.getSecureValue(SettingsKeyConstants.FINGERPRINT_TYPE_KEY, ''));
    log.showInfo(`fingerprint type:${fingerprintType}`);
    const isLowFingerprint = (fingerprintType === FingerprintType.UNDER_SCREEN_SENSOR_LOW);
    const value: string = sSettingsUtil.getValueBySECURE('fp_keyguard_enable') ?? '';
    this.isLowPosFingerPrint = isLowFingerprint && value === '1';
    if (!this.isLowPosFingerPrint) {
      // 如果锁屏指纹显示是低指纹位，则锁屏通知样式默认列表态
      this.ntfScreenLockUpperStyleInit();
    } else {
      this.isShow = true;
    }
  }

  async hasDistributionSet(): Promise<boolean> {
    try {
      const result = await getDistributedDeviceList();
      log.showInfo(`first distribute, ${result.length}`)
      return result.length !== 0;
    } catch (e) {
      LogWithHa.error(log, `get distribution state error ${e}`,
        SettingExceptionCode.GET_FIRST_DISTRIBUTION_STATE_FAIL, e);
      return false;
    }
  }

  private onDistributionButtonChange = (event: NotificationConfigEvent): void => {
    if (event[0] === NTF_DISTRIBUTION_BUTTON_EVENT) {
      // 监听到首次协同事件后，显示开关条目，并将监听解注册，转移至NotificationDistributeComponent监听开关按钮变化
      this.isSubscribed = false;
      notificationSettingManager.unsubscribeChangeEvent(this.onDistributionButtonChange);
      this.isDistributionSetBefore = true;
   }
  }

  build() {
    if (DeviceHelper.isPhoneOrPad()) {
      // HdsNavDestination() {
      NavDestination() {
        Row().height($r('app.float.page_title_height')).margin({ top: this.statusBarModel.height })
        this.buildMoreNtfSettingDetail()
      }
      .hideBackButton(this.hideBackButton && !this.isFromHome)
      // .titleBar(SysUIHdsNavigations.getTitleBarOptions(this.headName))
      .title(this.headName)
      .onShown(this.onDestinationShown)
      .systemTransition(this.transitionType)
      .onBackPressed(this.onDestinationBackPressed)
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    } else if (this.isFromHome) {
      NavDestination() {
        this.buildMoreNtfSettingDetail()
      }
      .onShown(()=>{
        this.initHideBannerContent();
      })
      .title(ResourceUtil.getStringSync(this.headName) ?? '')
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      .padding({ top: this.statusBarModel.height })
    } else {
      this.buildMoreNtfSettingDetail()
    }
  }

  private onDestinationShown = (): void => {
    this.initHideBannerContent();
  }

  private onDestinationBackPressed = (): boolean => {
    log.showInfo('OnDestinationBackPressed. %{public}s, %{public}s', this.isFromHome, this.hideBackButton);
    if (!this.isFromHome && !this.hideBackButton) {
      PageStorages.popContext();
    }
    return false;
  }

  private setDestinationEntryType(): void {
    if (!DeviceHelper.isPhoneOrPad()) {
      return;
    } else if (this.isFromHome) {
      this.transitionType = NavigationSystemTransitionType.DEFAULT;
    } else {
      this.transitionType = NavigationSystemTransitionType.TITLE;
    }
  }

  onPageShow(): void {
    this.initHideBannerContent();
  }

  @Builder
  buildMoreNtfSettingDetail() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Column() {
          this.buildMoreNtfSettingGridContainer();
        }
        .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
        .width(ConfigData.WH_100_100)
        .height(ConfigData.WH_100_100)
      } //具体应用通知设置
      .width(ConfigData.WH_100_100)
    }
    .layoutWeight(1)
    .width(ConfigData.WH_100_100)
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .padding({ start: this.isLandscape ? LengthMetrics.vp(39) : LengthMetrics.vp(0) })
  }

  @Builder
  buildMoreNtfSettingGridContainer() {
    GridContainer({
      columns: 12,
      sizeType: SizeType.Auto,
      gutter: vp2px(1) === 2 ? '12vp' : '0vp',
      margin: vp2px(1) === 2 ? '12vp' : '0vp'
    }) {
      Column() {
        if (!this.isFromHome && !DeviceHelper.isPhoneOrPad()) {
          HeadComponent({ headName: $r('app.string.more_ntf_setting'), hideBackButton: this.hideBackButton });
        }
        this.buildScrollBuilder();
      }
      .width(ConfigData.WH_100_100)
      .height(ConfigData.WH_100_100)
      .padding({
        left: DeviceHelper.isPC() ? 12 : $r('app.float.default_scroll_padding'),
        right: DeviceHelper.isPC() ? 12 : $r('app.float.default_scroll_padding'),
      })
    }
  }

  @Builder
  buildScrollBuilder() {
    Scroll(this.scroller) {
      Column() {
        this.buildNtfLabel(lockLabelName);
        if (!DeviceHelper.isPC()) {
          this.buildScreenLockColumn();
        }

        Column() {
          NtfMgmtSwitchItemsComponent();
        }
        .margin({ top: $r('app.float.page_NtfMoreSetting_title_margin') })

        Column() {
          NtfDisplayContentSelectComponent({
            isSupportSmartNtf: this.isSupportSmartNtf,
            isSupportSwingOnScreenLock: false,
            isFacialUnlockEnabled: (this.hasFaceData && this.isFaceOpen) ? true : false,
          });
        }
        .margin({ top: $r('app.float.page_NtfMoreSetting_title_margin') })

        Column() {
          NtfDisplayLiveWindowContent();
        }
        .margin({
          top: this.isSupportSmartNtf ? $r('app.float.page_notice_info_label_margin') :
          $r('app.float.page_NtfMoreSetting_title_margin')
        })

        Column() {
          NftBadgeSwitchItemsComponent();
        }
        .margin({ top: $r('app.float.page_notice_info_label_margin') })

        if (DeviceHelper.isPad() && this.isDistributionSetBefore) {
          Column() {
            NotificationDistributeComponent();
          }
          .margin({ top: $r('app.float.page_NtfMoreSetting_title_margin') })
        }
      }
      .margin({ bottom: $r('app.float.status_bar_setting_bottom_height') })
    }
    .align(Alignment.Top)
    .layoutWeight(1)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
    .borderRadius($r('app.float.border_radius'))
  }

  /**
   * 锁屏通知显示样式 初始化
   * @returns
   */
  async ntfScreenLockUpperStyleInit(): Promise<boolean> {
    return new Promise((resolve: (value: boolean | PromiseLike<boolean>) => void) => {
      const devValue: string = SettingsConstants.NTF_LOCK_SCREEN_STYLE_UPPER ? 'true' : 'false';
      let value = sSettingsUtil.getSecureValue(SettingsKeyConstants.NTF_SCREEN_LOCK_STYLE, devValue);
      log.showInfo('switchNtfScreenLockStyleInit: [%{public}s]', value);
      this.initUpperState = value === 'true';
      this.initLowerState = value === 'false';
      this.isShow = true;
      resolve(value === 'true');
    });
  }

  async ntfScreenLockLowerStyleInit(): Promise<boolean> {
    return new Promise((resolve: (value: boolean | PromiseLike<boolean>) => void) => {
      const devValue: string = SettingsConstants.NTF_LOCK_SCREEN_STYLE_UPPER ? 'true' : 'false';
      let value = sSettingsUtil.getSecureValue(SettingsKeyConstants.NTF_SCREEN_LOCK_STYLE, devValue);
      log.showInfo('switchNtfScreenLockStyleInit: [%{public}s]', value);
      resolve(value === 'true');
    });
  }

  /**
   * 切换 锁屏通知显示样式，设置是否高位显示锁屏通知
   * @param on
   */
  switchNtfScreenLockStyle(on: boolean): void {
    let result: boolean = sSettingsUtil.setSecureValue(SettingsKeyConstants.NTF_SCREEN_LOCK_STYLE, on ? 'true' : 'false');
    log.showInfo('switchNtfScreenLockStyle: [%{public}s], result [%{public}s]', on, result);
  }

  @Builder
  buildScreenLockColumn() {
    Column() {
      this.buildScreenLockNtfStyle();
    }
    .height($r('app.float.page_setEnable_list_height'))
    .align(Alignment.Center)
    .alignItems(HorizontalAlign.Center)
    .padding({ top:'24vp', bottom:'16vp' })
    .border({ width: 0, color: $r('app.color.card_panel_bg'),
      radius: $r('app.float.ntf_setting_item_card_radius') })
    .backgroundColor($r('sys.color.comp_background_list_card'))
  }

  @Builder
  buildScreenLockNtfStyle() {
    Flex({ justifyContent: FlexAlign.SpaceEvenly }) {
      if (this.isShow) {
        // 切换为收纳态
        this.buildLowerSwitch();
        // 切换为列表态
        this.buildUpperSwitch();
      }
    }.width(ConfigData.WH_100_100)
  }

  @Builder
  buildUpperSwitch() {
    enableComponent({
      settingAction: (enable: boolean | undefined) => {
        if (this.isLowPosFingerPrint) {
          return;
        }
        this.initUpperState = enable ?? false;
        this.initLowerState = !this.initUpperState;
        if (enable) {
          NtfSettingSysEventReporter.notificationLockScreenStyle({
            NTF_SCREEN_LOCK_STYLE: 0
          });
        }
        this.switchNtfScreenLockStyle(enable ?? true);
      },
      clickAction: (enable: boolean | undefined) => {
        if (this.isLowPosFingerPrint) {
          return;
        }
        AccessibilityManager.getInstance()?.sendAccessibility(getContext(this)?.resourceManager.getStringSync(enable ?
        $r('app.string.check_box_selected') : $r('app.string.check_box_unchecked')));
        log.showInfo(`screenLock notification show upper.`);
      },
      initializationAction: () =>
      new Promise((resolve : (value: boolean | PromiseLike<boolean>) => void) => {
        resolve(this.initUpperState);
      }),
      image: this.getUpperStateImage(),
      initState: this.initUpperState,
      isChangeEventFbd: this.isLowPosFingerPrint,
      customAccessibilityText: getContext(this)?.resourceManager.getStringSync($r('app.string.lock_screen_notification_expand')
        .id)
    })
      .width((this.isLandscape || DeviceHelper.isPC()) ? $r('app.float.enableListComp_default_item_width_land') : $r('app.float.enableListComp_default_item_land_width'))
  }

  @Builder
  buildLowerSwitch() {
    enableComponent({
      settingAction: (enable: boolean | undefined) => {
        if (this.isLowPosFingerPrint) {
          return;
        }
        this.initLowerState = enable ?? false;
        this.initUpperState = !this.initLowerState;
        if (enable) {
          NtfSettingSysEventReporter.notificationLockScreenStyle({
            NTF_SCREEN_LOCK_STYLE: 1
          });
        }
        this.switchNtfScreenLockStyle(!enable ?? false);
      },
      clickAction: (enable: boolean | undefined) => {
        if (this.isLowPosFingerPrint) {
          return;
        }
        AccessibilityManager.getInstance()?.sendAccessibility(getContext(this)?.resourceManager.getStringSync(enable ?
        $r('app.string.check_box_selected') : $r('app.string.check_box_unchecked')));
        log.showInfo(`screenLock notification show lower.`);
      },
      initializationAction: () =>
      new Promise((resolve : (value: boolean | PromiseLike<boolean>) => void) => {
        resolve(this.initLowerState);
      }),
      image: this.getLowerStateImage(),
      initState: this.initLowerState,
      isChangeEventFbd: this.isLowPosFingerPrint,
      toastMessage: $r('app.string.switch_screen_lock_ntf_style_forbidden'),
      customAccessibilityText: getContext(this)?.resourceManager.getStringSync($r('app.string.lock_screen_notification_fold')
        .id)
    })
      .width((this.isLandscape || DeviceHelper.isPC()) ? $r('app.float.enableListComp_default_item_width_land') : $r('app.float.enableListComp_default_item_land_width'))
  }

  /**
   * 通知Label
   */
  @Builder
  buildNtfLabel(labelName: Resource) {
    Row() {
      Text(labelName)
        .draggable(false)
        .fontColor($r('app.color.app_color_text_secondary'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .maxFontScale(2)
        .fontWeight(FontWeight.Medium)
        .fontFamily('HarmonyHeiTi-Medium');
    }
    .alignItems(VerticalAlign.Bottom)
    .width('100%')
    .constraintSize({ minHeight: $r('app.float.page_label_phrases_height') })
    .padding({ start: LengthMetrics.vp(12), bottom: LengthMetrics.vp(8) })
    .visibility(DeviceHelper.isPhoneOrPad() ? Visibility.Visible : Visibility.None)
  }

  /**
   * 通知开关Intro
   */
  @Builder
  buildNtfIntro(labelName: Resource) {
    Row() {
      Text(labelName)
        .draggable(false)
        .fontColor($r('app.color.app_color_text_secondary'))
        .fontSize($r('sys.float.ohos_id_text_size_body3'))
        .fontWeight(FontWeight.Regular)
        .fontFamily('HarmonyHeiTi-Medium');
    }
    .alignItems(VerticalAlign.Top)
    .width('100%')
    .padding({ start: LengthMetrics.resource($r('sys.float.ohos_id_default_padding_start')), top: LengthMetrics.vp(8), bottom: LengthMetrics.vp(16) })
    .visibility(DeviceHelper.isPhoneOrPad() ? Visibility.Visible : Visibility.None)
  }

  private getUpperStateImage() : Resource {
    return this.initUpperState ? $r('app.media.pic_list_down_check') : $r('app.media.pic_list_down_grey');
  }

  private getLowerStateImage() : Resource {
    return this.initLowerState ? $r('app.media.pic_bottom_check') : $r('app.media.pic_bottom_grey');
  }

  onNavModeChanged() {
    log.showInfo('navigationMode is [%{public}d]', this.navMode);
    this.hideBackButton = this.navMode === NavigationMode.Split;
  }
}
