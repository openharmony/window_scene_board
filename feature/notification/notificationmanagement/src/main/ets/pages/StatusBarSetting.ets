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
  EvtBus,
  EventManager,
  GlobalContext
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import {
  SettingsConstants,
  SettingsKeyConstants
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import { DeviceHelper, sSettingsUtil } from '@ohos/managementcomponent';
import { HiDfxEventUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/HiDfxEventUtil';
import ConfigData from '../common/constants';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import StatueBarSwitchComponent from './StatueBarSwitchComponent';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';
import { NotificationSysEventUtil } from '../common/NotificationSysEventUtil';
import HeadComponent from '@ohos/managementcomponent/src/main/ets/com/ohos/view/component/headComponent';
import Sim from '@ohos.telephony.sim';
import { fontScaleManager, FontScaleState } from '@ohos/managementcomponent';
import { PageStorages } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/PageStorages';
import { StatusBarModel } from '../model/StatusBarModel';
import NtfSettingUtil from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingUtil';
import { ResourceUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/ResourceUtil';
// import { HdsNavDestination, HdsNavDestinationAttribute } from '@kit.UIDesignKit';
import { SysUIHdsNavigations } from '../common/SysUIHdsNavigations';
import { StatusBarSettingItem } from './StatusBarSettingItem';
import { StatusBarSettingModel } from '../model/StatusBarSettingModel';
import { ColorModeEvent, ColorMode } from '../common/Events';
import { LengthMetrics } from '@kit.ArkUI';

const TAG = 'NotificationManagement-StatusBarSetting';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const COMPONENT_ID_BAR = TAG + '_Image_status_bar_pure';

const ICON_COLOR_DARK = $r('app.color.status_bar_setting_icon_color_dark');
const ICON_COLOR_LIGHT = $r('app.color.status_bar_setting_icon_color_light');

@Entry
@Component
export struct StatusBarSetting {
  @State headName: Resource = $r('app.string.status_bar_title');
  @State pureShowTitle: Resource = $r('app.string.pure_show_title');
  @State pureShowDescription: Resource = $r('app.string.pure_show_description');
  @State pureShowImage: Resource = DeviceHelper.isPad() ? $r('app.media.setting_status_bar_pure_pad') :
  $r('app.media.setting_status_bar_pure');
  @State showNotificationIconTitle: Resource = $r('app.string.show_notification_icon');
  @State showRealTimeNetworkSpeedTitle: Resource = $r('app.string.show_real_time_network_speed');
  @StorageLink('isLandscape') isLandscape: boolean = false;
  @State hideBackButton: boolean = false;

  /**
   * 默认值为false，防止纯净显示关闭，显示通知图标打开的前提下，打开纯净显示开关，导致isPureShowEnable不变化，不刷新的问题
   */
  @State isPureShowEnable: boolean = false;
  @State settingModel: StatusBarSettingModel = StatusBarSettingModel.getInstance();
  @State isEnabledLive2: boolean = true;
  /**
   * 长辈模式字体
   */
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  @State transitionType: NavigationSystemTransitionType = NavigationSystemTransitionType.TITLE;
  @State desColor: string = '#99000000';

  /**
   * 导入对象
   */
  scroller: Scroller = new Scroller()
  ntfSettingUtil: NtfSettingUtil = new NtfSettingUtil();

  /**
   * 是否从通知和状态栏页面进入，为false的场景是从设置搜索直接跳转
   */
  private isFromNtfAndStatusBar: boolean = true;

  @StorageLink('navigationMode')
  @Watch('onNavModeChanged') navMode: number = AppStorage.get('navigationMode') ?? -1;
  @State statusBarModel: StatusBarModel = StatusBarModel.get();

  @Provide statusBarSettingIconColor: Resource = ICON_COLOR_LIGHT;

  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  private onColorMode = (event: ColorModeEvent) => {
    if (event.colorMode === ColorMode.COLOR_MODE_NOT_SET) {
      log.showInfo('ConfigurationEvent colorMode not set.');
      return;
    }
    this.setIconColor();
  }

  build() {
    if (DeviceHelper.isPhoneOrPad()) {
      NavDestination() {
        this.StatusBarSettingDetail()
      }
      .hideBackButton(this.hideBackButton && !this.isFromNtfAndStatusBar)
      .systemTransition(this.transitionType)
      .onBackPressed(this.onDestinationBackPressed)
      .title(ResourceUtil.getStringSync(this.headName) ?? '')
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    } else {
      if (this.isFromNtfAndStatusBar) {
        NavDestination() {
          this.StatusBarSettingDetail()
        }
        .title(ResourceUtil.getStringSync(this.headName) ?? '')
        .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
        .padding({ top: this.statusBarModel.height })
      } else {
        this.StatusBarSettingDetail()
      }
    }
  }

  private onDestinationBackPressed = (): boolean => {
    log.showInfo('OnDestinationBackPressed. %{public}s %{public}s', this.isFromNtfAndStatusBar, this.hideBackButton);
    if (!this.isFromNtfAndStatusBar && !this.hideBackButton) {
      PageStorages.popContext();
    }
    return false;
  }

  private setDestinationEntryType(): void {
    if (!DeviceHelper.isPhoneOrPad()) {
      return;
    } else if (this.isFromNtfAndStatusBar) {
      this.transitionType = NavigationSystemTransitionType.DEFAULT;
    } else {
      this.transitionType = NavigationSystemTransitionType.TITLE;
    }
  }

  @Builder
  DividerLine(hasIcon: boolean = true) {
    Divider().color($r('sys.color.ohos_id_color_list_separator')).strokeWidth('1px')
      .padding({
        start: LengthMetrics.vp(hasIcon ? 52 : 12),
        end: LengthMetrics.resource($r('app.float.switchComp_padding_r')),
      })
  }

  @Builder
  StatusBarSettingGroup(groupTitle: Resource) {
    Column() {
      Row() {
        Text(groupTitle)
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Medium)
          .lineHeight(this.fontScaleState.getScaleSize($r('app.float.setting_group_height')))
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .fontColor($r('app.color.app_color_text_secondary'))
          .width('100%')
          .margin({
            top: $r('app.float.setting_group_margin_top'),
            bottom: $r('app.float.setting_group_margin_bottom'),
          })
      }
      .justifyContent(FlexAlign.Start)
      .width('100%')
      .padding({
        left: $r('app.float.setting_group_padding_left_right'),
        right: $r('app.float.setting_group_padding_left_right'),
      })

      this.IconSwitch();
    }
  }

  @Builder
  IconSwitch() {
    Column() {
      StatusBarSettingItem({ settingKey: SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON })
      this.DividerLine(false);
      StatusBarSettingItem({ settingKey: SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED })
    }
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .border({
      width: $r('app.float.border_width'), color: $r('app.color.background_transparent'),
      radius: $r('app.float.setting_group_radius')
    })
    .padding({
      top: $r('app.float.setting_group_item_padding_top_bottom'),
      bottom: $r('app.float.setting_group_item_padding_top_bottom')
    })

    Column() {
      // VPN
      StatusBarSettingItem({ settingKey: SettingsKeyConstants.SHOW_VPN_ICON })
      this.DividerLine();
      // 响铃
      StatusBarSettingItem({ settingKey: SettingsKeyConstants.SHOW_RING_MODE_ICON })
      this.DividerLine();
      // 蓝牙/星闪
      StatusBarSettingItem({ settingKey: SettingsKeyConstants.SHOW_NEARLINK_ICON })
      this.DividerLine();
      // 闹钟
      StatusBarSettingItem({ settingKey: SettingsKeyConstants.SHOW_ALARM_CLOCK_ICON })
      this.DividerLine();
      // NFC
      if (this.settingModel.supportNFC) {
        StatusBarSettingItem({ settingKey: SettingsKeyConstants.SHOW_NFC_ICON })
        this.DividerLine();
      }
      // 有线耳机
      StatusBarSettingItem({ settingKey: SettingsKeyConstants.SHOW_HEAD_PHONES_ICON })
    }
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .border({
      width: $r('app.float.border_width'),
      color: $r('app.color.background_transparent'),
      radius: $r('app.float.setting_group_radius')
    })
    .margin({ top: $r('app.float.page_margin_l') })
    .padding({
      top: $r('app.float.setting_group_item_padding_top_bottom'),
      bottom: $r('app.float.setting_group_item_padding_top_bottom')
    }) // 由于边框会占用1宽度，所以内边距由4改为3
    // 功能说明
    this.switchDescription();
  }

  @Builder
  switchDescription() {
    Stack({alignContent: Alignment.Start }) {
      Text($r('app.string.enable_switch_explain'))
        .margin({ top: 8, left: $r('app.float.setting_group_padding_left_right'), right: $r('app.float.setting_group_padding_left_right')})
        .fontWeight(FontWeight.Regular)
        .fontFamily('HarmonyHeiTi')
        .fontSize(12)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
    }
    .width('100%')
  }

  @Builder
  StatusBarSettingDetail() {
    Column() {
      Column() {
        if (!this.isFromNtfAndStatusBar && !DeviceHelper.isPhoneOrPad()) {
          HeadComponent({ headName: this.headName, hideBackButton: this.hideBackButton })
        }
        Scroll(this.scroller) {
          if (this.isEnabledLive2) {
            if (DeviceHelper.isPhoneOrPad()) {
              Column() {
                this.StatusBarSettingGroup($r('app.string.enable_switch_icon_visible'));
              }
              .width('100%')
            }
          } else {
            Column() {
              if (DeviceHelper.isPhoneOrPad()) {
                this.PureShowComponent()
              }
              Column() {
                this.ShowNotificationIcon()
              }
              .backgroundColor($r('sys.color.comp_background_list_card'))
              .border({
                width: $r('app.float.border_width'), color: $r('app.color.card_panel_bg'),
                radius: $r('app.float.border_radius')
              })
              .padding({ top: $r('app.float.noDisturb_margin_lf') })
              .margin({ top: $r('app.float.page_status_bar_setting_show_notification_icon_margin_t') })
            }
            .margin({ bottom: $r('app.float.status_bar_setting_bottom_height') }) // 滚动组件底部间距
          }
        }
        .scrollBar(BarState.Off)
        .borderRadius($r('app.float.border_radius'))
        .edgeEffect(EdgeEffect.Spring)
        .height(ConfigData.WH_100_100)
        .align(Alignment.Top)
        .margin({ bottom: this.isEnabledLive2 ? $r('app.float.setting_panel_margin_bottom') : $r('app.float.page_status_bar_setting_margin_t') })
        .layoutWeight(1)
      }
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      .padding({ left: '16vp', right: '16vp' })
      .width(ConfigData.WH_100_100)
    }
    .width(ConfigData.WH_100_100)
    .padding({ left: this.isLandscape ? $r('app.float.page_notice_and_status_bar_padding') : 0 })
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .layoutWeight(1)
  }

  @Builder
  PureShowComponent() {
    Column() {
      StatueBarSwitchComponent({
        title: $pureShowTitle,
        describe: (Object)(this.pureShowDescription),
        initializationAction: () => this.pureShowInit(),
        settingAction: (params?: boolean) => {
          if (params != undefined) {
            this.switchPureShow(params)
          }
        },
        externalChange: false
      }).margin({ top: $r('app.float.pure_show_margin_top'),
        bottom: $r('app.float.pure_show_margin_bottom') })
        .id(TAG + '_statueBarSwitchComponent_pureShow')

      Image(this.pureShowImage)
        .draggable(false)
        .id(COMPONENT_ID_BAR)
        .objectFit(ImageFit.Contain)
        .width($r('app.float.pure_icon_height'))
        .height($r('app.float.pure_icon_width'))
        .opacity(1)
        .margin({
          top: this.fontScaleState.getScaleSize($r('app.float.pure_icon_margin_top')),
          bottom: $r('app.float.pure_icon_margin_bottom')
        })
    }
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .border({ width: 0, color: $r('app.color.card_panel_bg'),
      radius: $r('app.float.border_radius') })
  }

  @Builder
  ShowNotificationIcon() {
    if (DeviceHelper.isPhoneOrPad()) {
      StatueBarSwitchComponent({
        title: $showNotificationIconTitle,
        initializationAction: () => this.showNotificationIconInit(),
        initlastUserSwitchState: () => this.showNotificationIconLastSwitchStateInit(),
        settingAction: (params?: boolean, lastUserSwitchState?: boolean) => {
          if (params != undefined) {
            this.switchShowNotificationIcon(params);
          }
          if (lastUserSwitchState != undefined) {
            let result = sSettingsUtil.setSecureValue(SettingsKeyConstants.NOTIFICATION_ICON_LAST_SWITCH_STATE, lastUserSwitchState ? 'true' : 'false', ContextManager.getContext());
            log.showInfo(`notificationIconLastSwitchState: ${lastUserSwitchState}, result:${result}`);
          }
        },
        externalChange: this.isPureShowEnable
      }).id(TAG + '_statueBarSwitchComponent_showNotificationIcons')

      Divider().color($r('sys.color.ohos_id_color_list_separator')).strokeWidth('1px')
        .padding({
          left: $r('app.float.switchComp_padding_r'),
          right: $r('app.float.switchComp_padding_r'),
        })

      StatueBarSwitchComponent({
        title: $showRealTimeNetworkSpeedTitle,
        initializationAction: () => this.showRealTimeNetworkSpeedInit(),
        initlastUserSwitchState: () => this.showRealTimeNetworkLastSwitchStateInit(),
        settingAction: (params?: boolean, lastUserSwitchState?: boolean) => {
          if (params != undefined) {
            this.switchShowRealTimeNetworkSpeed(params);
          }
          if (lastUserSwitchState != undefined) {
            let result = sSettingsUtil.setSecureValue(SettingsKeyConstants.REAL_TIME_NETWORK_SPEED_LAST_SWITCH_STATE, lastUserSwitchState ? 'true' : 'false', ContextManager.getContext());
            log.showInfo(`realTimeNetworkLastSwitchState :${lastUserSwitchState}, result:${result}`);
          }
        },
        externalChange: this.isPureShowEnable
      }).id(TAG + '_statueBarSwitchComponent_showNetworkSpeed')
    }
  }

  aboutToAppear(): void {
    try {
      this.isEnabledLive2 = systemParameterEnhance.getSync('persist.systemui.live2', 'false') === 'true';
    } catch (error) {
      log.showError(`Init systemui.live2 check false ${error}`);
    }
    log.showInfo(`aboutToAppear ${this.isEnabledLive2}`);
    // 设备SIM卡支持情况查询
    try {
      const simCount = Sim.getMaxSimCount();
      if (simCount === 0) {
        this.pureShowDescription = $r('app.string.pad_pure_show_description');
      }
      log.showInfo(`check device support SIM Card ${simCount}`);
    } catch (error) {
      log.showError(`get max sim count error: ${error?.code}, message：${error?.message} `);
    }

    // 设备NFC支持情况查询
    try {
      const isSupport = canIUse('SystemCapability.Communication.NFC.Core');
      log.showInfo(`check device support NFC: ${isSupport}`);
      this.settingModel.supportNFC = isSupport;
    } catch (error) {
      log.showError(`check device support nfc failed:：${error?.message} `);
    }

    // 设备震动支持情况查询
    try {
      const isSupport: boolean = systemParameterEnhance.getSync('const.vibrator.support_vibrator', 'true') === 'true';
      log.showInfo(`check device support vibrator ${isSupport}`);
      this.settingModel.supportVibration = isSupport;
    } catch (error) {
      log.showError(`check device support vibrator failed: ${error?.massage}`);
    }

    // 设备星闪支持情况查询
    try {
      const isSupport: boolean = systemParameterEnhance.getSync('const.nearlink.enable', 'false') === 'true';
      log.showInfo(`check device support nearlink ${isSupport}`);
      this.settingModel.supportNearLink = isSupport;
    } catch (error) {
      log.showError(`check device support nearlink failed: ${error?.massage}`);
    }
    this.isFromNtfAndStatusBar = PageStorages.getPageContext()?.isFromHome ?? true;
    if (!this.isFromNtfAndStatusBar) {
      this.navMode = this.ntfSettingUtil.navModeInit();
    }
    this.hideBackButton = this.navMode === NavigationMode.Split;
    let isPureShow = sSettingsUtil.getSecureValue(SettingsKeyConstants.STATUS_BAR_PURE_SHOW,
      SettingsConstants.STATUS_BAR_PURE_SHOW_DEFAULT ? 'true' : 'false', ContextManager.getContext());
    this.isPureShowEnable = isPureShow === 'true' ? true : false;
    this.setDestinationEntryType();
    log.showInfo(`aboutToAppear, 注册display事件`);
    this.setIconColor();

    try {
      this.eventMgr.on(ColorModeEvent, this.onColorMode);
    } catch (e) {
      log.showError(`register ColorModeEvent error, err is ${e?.message}`);
    }

    StatusBarSettingModel.getInstance().registerListenSettingData();
  }

  aboutToDisappear(): void {
    log.showDebug(`aboutToDisappear`);
    this.eventMgr.offAll();
    StatusBarSettingModel.getInstance().unRegisterListenSettingData();
  }

  private setIconColor(): void {
    try {
      let colorMode = GlobalContext.getContext().config.colorMode;
      if (colorMode === ColorMode.COLOR_MODE_DARK) {
        this.statusBarSettingIconColor = ICON_COLOR_DARK;
        this.desColor = `#99FFFFFF`;
      } else {
        this.statusBarSettingIconColor = ICON_COLOR_LIGHT;
        this.desColor = `#99000000`;
      }

    } catch (e) {
      log.showError(`setIconColor err, ${e?.message}`);
    }

  }

  onBackPress(): void {
    HiDfxEventUtil.reportNotificationManagementStatusBar(HiDfxEventUtil.LEAVE_PAGE);
  }

  async pureShowInit() : Promise<boolean> {
    return new Promise((resolve : (value: boolean) => void) => {
      let isPureShow = sSettingsUtil.getSecureValue(SettingsKeyConstants.STATUS_BAR_PURE_SHOW,
        SettingsConstants.STATUS_BAR_PURE_SHOW_DEFAULT ? 'true' : 'false', ContextManager.getContext());
      log.showInfo(`pureShowInit, get isPureShow: ${isPureShow}`);
      resolve(isPureShow === 'true');
    });
  }

  switchPureShow(on: boolean) : void {
    let result = sSettingsUtil.setSecureValue(SettingsKeyConstants.STATUS_BAR_PURE_SHOW, on ? 'true' : 'false', ContextManager.getContext());
    if (result) {
      this.isPureShowEnable = on;
    }
    HiDfxEventUtil.reportSimpleDisplay(on ? HiDfxEventUtil.STATE_OPEN : HiDfxEventUtil.STATE_CLOSE);
    NotificationSysEventUtil.reportSysUiSettingModify('PURE', on ? HiDfxEventUtil.STATE_OPEN : HiDfxEventUtil.STATE_CLOSE);
    log.showInfo(`switchPureShow:${on}, result:${result}`);
  }

  async showNotificationIconInit() : Promise<boolean> {
    return new Promise((resolve : (value: boolean) => void) => {
      let isShowNotificationIcon = sSettingsUtil.getSecureValue(SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON,
        SettingsConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON_DEFAULT ? 'true' : 'false', ContextManager.getContext());
      log.showInfo(`showNotificationIconInit, get isShowNotificationIcon: ${isShowNotificationIcon}`);
      resolve(isShowNotificationIcon === 'true');
    });
  }

  async showNotificationIconLastSwitchStateInit() : Promise<boolean> {
    return new Promise((resolve : (value: boolean) => void) => {
      let notificationIconLastSwitchState = sSettingsUtil.getSecureValue(
        SettingsKeyConstants.NOTIFICATION_ICON_LAST_SWITCH_STATE,
        SettingsConstants.NOTIFICATION_ICON_LAST_SWITCH_STATE_DEFAULT,
        ContextManager.getContext());
      log.showInfo(`showNotificationIconLastSwitchStateInit, get notificationIconLastSwitchState: ${notificationIconLastSwitchState}`);
      resolve(notificationIconLastSwitchState === 'true');
    });
  }

  switchShowNotificationIcon(on: boolean) : void {
    let result = sSettingsUtil.setSecureValue(SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON, on ? 'true' : 'false', ContextManager.getContext());
    log.showInfo(`switchShowNotificationIcon:${on}, result:${result}`);
    HiDfxEventUtil.reportShowAppNotificationIcons(on ? HiDfxEventUtil.STATE_OPEN : HiDfxEventUtil.STATE_CLOSE);
    NotificationSysEventUtil.reportSysUiSettingModify('NTF', on ? HiDfxEventUtil.STATE_OPEN : HiDfxEventUtil.STATE_CLOSE);
  }

  changeShowNotificationIcon(isPureShowDisable: boolean): boolean | void {
    if (!isPureShowDisable) {
      return false;
    }
  }

  getNotificationIconState(): Promise<boolean> {
    return new Promise((resolve: (value: boolean) => void) => {
      let currentState = sSettingsUtil.getSecureValue(SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON,
        SettingsConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON_DEFAULT ? 'true' : 'false', ContextManager.getContext());
      resolve(currentState === 'true');
    });
  }

  async showRealTimeNetworkSpeedInit() : Promise<boolean> {
    return new Promise((resolve: (value: boolean) => void) => {
      let isShowRealTimeNetworkSpeed = sSettingsUtil.getSecureValue(
        SettingsKeyConstants.STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED,
        SettingsConstants.STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED_DEFAULT ? 'true' : 'false',
        ContextManager.getContext());

      log.showInfo(`showRealTimeNetworkSpeedInit, get isShowRealTimeNetworkSpeed: ${isShowRealTimeNetworkSpeed}`);
      resolve(isShowRealTimeNetworkSpeed === 'true');
    });
  }

  async showRealTimeNetworkLastSwitchStateInit() : Promise<boolean> {
    return new Promise((resolve: (value: boolean) => void) => {
      let realTimeNetWorkLastSwitchState = sSettingsUtil.getSecureValue(
        SettingsKeyConstants.REAL_TIME_NETWORK_SPEED_LAST_SWITCH_STATE,
        SettingsConstants.REAL_TIME_NETWORK_SPEED_LAST_SWITCH_STATE_DEFAULT,
        ContextManager.getContext());
      log.showInfo(`showRealTimeNetworkLastSwitchStateInit, get realTimeNetWorkLastSwitchState: ${realTimeNetWorkLastSwitchState}`);
      resolve(realTimeNetWorkLastSwitchState === 'true');
    });
  }

  switchShowRealTimeNetworkSpeed(on: boolean) : void {
    let result = sSettingsUtil.setSecureValue(SettingsKeyConstants.STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED, on ? 'true' : 'false', ContextManager.getContext());
    log.showInfo(`switchShowRealTimeNetworkSpeed:${on}, result:${result}`);
    HiDfxEventUtil.reportShowNetworkSpeed(on ? HiDfxEventUtil.STATE_OPEN : HiDfxEventUtil.STATE_CLOSE);
    NotificationSysEventUtil.reportSysUiSettingModify('NET_SPEED', on ? HiDfxEventUtil.STATE_OPEN : HiDfxEventUtil.STATE_CLOSE);
  }

  getRealTimeNetworkSpeedState(): Promise<boolean> {
    return new Promise((resolve: (value: boolean) => void) => {
      let currentState = sSettingsUtil.getSecureValue(SettingsKeyConstants.STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED,
        SettingsConstants.STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED_DEFAULT ? 'true' : 'false', ContextManager.getContext());
      resolve(currentState === 'true');
    });
  }

  onNavModeChanged() {
    log.showInfo('navigationMode is [%{public}d]', this.navMode);
    this.hideBackButton = this.navMode === NavigationMode.Split;
  }
}
