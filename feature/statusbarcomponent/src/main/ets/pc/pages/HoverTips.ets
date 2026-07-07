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

import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { ResourceManager, PluginSlot, EventManager, EvtBus, PluginAccessInfo } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { StatusBarTipsChangeEvent } from '@ohos/systemuicommon';
import i18n from '@ohos.i18n';
import intl from '@ohos.intl';
import wifiManager from '@ohos.wifiManager';
import bundleManager from '@ohos.bundle.bundleManager';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/constants/StyleConstants';
import { AudioDeviceType, TurboChargingStatus } from '../utils/enum';
import InputMethodSubtype from '@ohos.InputMethodSubtype';
import inputMethod from '@ohos.inputMethod';
import { Constants } from '../common/Constants';
import { KeyboardBatteryMgr, ChargingState } from '../../common/KeyboardBatteryMgr';
import measure from '@ohos.measure';
import {
  pluginDistributedController
} from '@ohos/wificomponent/src/main/ets/default/controller/PluginDistributedController';
import { LengthMetrics } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { common } from '@kit.AbilityKit';
import InputMethodUtils from '@ohos/inputmethodcomponent/src/main/ets/default/common/InputMethodUtils';
import { PluginProperty } from '../viewdata/PluginProperty';
import { PluginListAdapter } from '../pluginData/PluginListAdapter';

const TAG = 'HoverTips';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const HOVER_TIPS_DELAY: number = 300;
const CHARGING_FULL: number = 3;
const KEYBOARD_FULL_BATTERY: number = 100;
const TIPS_TEXT_PADDING: number = 2;
const TIPS_MAP = new Map<string, string>([
  [PluginSlot.SLOT_STATUS_SMART_SCREENSHOT, '+Shift+S'],
  [PluginSlot.SLOT_STATUS_CAPSULE_SCREENSHOT, ' F11'],
  [PluginSlot.SLOT_STATUS_SCREEN_RECORDER, ' F10']
]);
const TIPS_MAP_RTL = new Map<string, string>([
  [PluginSlot.SLOT_STATUS_SMART_SCREENSHOT, 'S+Shift+'],
  [PluginSlot.SLOT_STATUS_CAPSULE_SCREENSHOT, 'F11 '],
  [PluginSlot.SLOT_STATUS_SCREEN_RECORDER, 'F10 ']
]);

@Component
export struct HoverTips {
  @StorageLink('systemLanguage') @Watch('onLanguageChange') language: string = '';
  @StorageLink('curDeviceTypeForHoverTips') @Watch('refreshSoundTipText') curDeviceType: number = 2;
  @StorageLink('volumePercentForHoverTips') @Watch('refreshSoundTipText') volumePercentText: number = 0;
  @StorageLink('MicrophonePanelCurrentEnable') @Watch('refreshMicrophoneTipText') microphonePanelCurrentEnable: boolean = true;
  @StorageLink('MicrophonePanelCurrentPNREnable') @Watch('refreshMicrophoneTipText') isPNREnable: boolean = false;
  @StorageLink('MicrophonePanelCurrentAINREnable') @Watch('refreshMicrophoneTipText') isAINREnable: boolean = false;
  @StorageLink('MicrophonePanelCurrentRecordNoiseReductEnable') @Watch('refreshMicrophoneTipText') isReductNow: boolean = false;
  @State currentInputMethod: inputMethod.InputMethodProperty | null = null;
  @State currentInputMethodSubtype: InputMethodSubtype | null = null;
  @State mDay: string = '';
  @State mWeek: string = '';
  @State mTime: string = '16:01';
  @State date: Date = new Date();
  @State is24HourFormat: boolean = false;
  @State weekDay: number = -1;
  @State pluginSlot: string = '';
  @State bundleName: string = '';
  @State moduleName: string = '';
  @State appIndex: number = 0;
  @State abilityName: string = '';
  @State hoverTipsContent: string = '';
  @State hoverTipsShortcutContent: string = '';
  private screenWidth: number = AppStorage.get<number>('screenWidth') as number;
  private screenHeight: number = AppStorage.get<number>('screenHeight') as number;
  private readonly FORMAT_TIME_24H: intl.DateTimeOptions = { timeStyle: 'short', hourCycle: 'h24' };
  private readonly FORMAT_TIME_12H: intl.DateTimeOptions = { timeStyle: 'short', hourCycle: 'h12' };
  private ethernetTipString: string = AppStorage.get<boolean>('EthernetAvailableStatus') ?
    ResUtils.getInnerStringByName('ethernet_status_connected') : '';

  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    this.getPluginText(this.pluginSlot);
    this.getShortcutText(this.pluginSlot);
    this.eventMgr.on(StatusBarTipsChangeEvent, this.refreshTips);
  }

  private refreshTips = (statusBarTipsChangeEvent: StatusBarTipsChangeEvent) => {
    log.showInfo(`refreshTips, statusBarTipsChangeEvent slot: ${statusBarTipsChangeEvent.slot}, pluginSlot: ${this.pluginSlot}`);
    if (statusBarTipsChangeEvent.slot !== this.pluginSlot) {
      return;
    }
    if (this.pluginSlot === PluginSlot.SLOT_STATUS_BATTERY_PANEL) {
      this.hoverTipsContent = this.getBatteryPluginTips(statusBarTipsChangeEvent.tips);
    } else if (this.pluginSlot === PluginSlot.SLOT_STATUS_WIFI_PANEL) {
      this.ethernetTipString = statusBarTipsChangeEvent.tips;
      this.hoverTipsContent = this.getWLANPluginTips();
    } else {
      this.hoverTipsContent = statusBarTipsChangeEvent.tips;
    }
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.eventMgr.offAll();
  }

  private getAppName(): void {
    let appName = 'fail';
    let resourceManager = ResourceManager.getInstance();
    let bundleName = this.bundleName;
    let moduleName = this.moduleName;
    let abilityName = this.abilityName;
    let appIndex = this.appIndex;
    let bundleFlags: number = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE;
    try {
      bundleManager.getBundleInfo(bundleName, bundleFlags).then((bundleInfo) => {
        let hapModuleInfos = bundleInfo.hapModulesInfo;
        for (let i: number = 0; i < hapModuleInfos.length; ++i) {
          let moduleInfo = hapModuleInfos[i];
          if (moduleInfo.name === moduleName) {
            resourceManager.getAppNameWithCache(moduleInfo.labelId, bundleName, moduleName, appName, (name: string) => {
              this.hoverTipsContent = name;
            }, appIndex);
            break;
          }
        }
      }).catch((err: BusinessError) => {
        log.showError(`get bundle info failed, err : ${err}`)
      })
      log.showInfo(`getAppName, appName:${appName}, bundleName:${bundleName}, moduleName:${moduleName}, abilityName:${abilityName}, `);
    } catch (err) {
      log.showError(`get app name failed, err : ${err}`)
    }
  }

  private async getPluginText(pluginSlot: string): Promise<void> {
    switch (pluginSlot) {
      case PluginSlot.SLOT_STATUS_PERSONAL:
        this.hoverTipsContent = ResUtils.getInnerStringByName('personal_panel');
        break;
      case PluginSlot.SLOT_STATUS_ENTERPRISE_SPACE:
        this.hoverTipsContent = ResUtils.getInnerStringByName('space_switching');
        break;
      case PluginSlot.SLOT_STATUS_CONTROL_CENTER:
        this.hoverTipsContent = ResUtils.getInnerStringByName('control_center');
        break;
      case PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL:
        this.hoverTipsContent = ResUtils.getInnerStringByName('ntf_center_title');
        break;
      case PluginSlot.SLOT_STATUS_CLOCK_PANEL:
        this.hoverTipsContent = this.getClockPluginTips(new Date());
        break;
      case PluginSlot.SLOT_STATUS_WIFI_PANEL:
        this.hoverTipsContent = this.getWLANPluginTips();
        break;
      case PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL:
        this.hoverTipsContent = ResUtils.getInnerStringByName('control_center_complex_toggle_bluetooth_title');
        break;
      case PluginSlot.SLOT_STATUS_SOUND_PANEL:
        this.hoverTipsContent = this.getSoundPluginTips();
        break;
      case PluginSlot.SLOT_STATUS_MICROPHONE_PANEL:
        this.hoverTipsContent = this.getMircophonePluginTips();
        break;
      case PluginSlot.SLOT_STATUS_SMART_SCREENSHOT:
        this.hoverTipsContent = ResUtils.getInnerStringByName('smart_screenshot');
        break;
      case PluginSlot.SLOT_STATUS_INPUT_PANEL:
        this.hoverTipsContent = await this.getInputMethodSubType();
        break;
      case PluginSlot.SLOT_STATUS_INPUT_METHOD:
        this.hoverTipsContent = await this.getInputMethod();
        break;
      case PluginSlot.SLOT_STATUS_LOCATION:
        this.hoverTipsContent = ResUtils.getInnerStringByName('cc_accessibility_str_privacy_string_location');
        break;
      case PluginSlot.SLOT_STATUS_USB:
        this.hoverTipsContent = ResUtils.getInnerStringByName('usb_hover');
        break;
      case PluginSlot.SLOT_STATUS_FOCUS_MODE_PADDLE:
        this.hoverTipsContent = ResUtils.getInnerStringByName('not_disturb_title');
        break;
      case PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE:
        this.hoverTipsContent = ResUtils.getInnerStringByName('super_privacy_toggle');
        break;
      case PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT:
        this.hoverTipsContent = ResUtils.getInnerStringByName('super_privacy_toggle');
        break;
      case PluginSlot.SLOT_CAPSULE_KEY_MOUSE:
        this.hoverTipsContent = ResUtils.getInnerStringByName('key_mouse_sharing');
        break;
      case PluginSlot.SLOT_STATUS_QUICK_NOTE:
        ResUtils.getOutStringByName('notepad_quick_note_title', this.bundleName).then((name) => {
          this.hoverTipsContent = name;
        });
        break;
      default:
        const pluginInfo: PluginProperty | null  = PluginListAdapter.getInstance().getPluginPropertyBySlot(pluginSlot) as PluginProperty;

        let hoverTips = '';
        if (pluginInfo && pluginInfo.pluginInfo) {
          hoverTips = (pluginInfo.pluginInfo as PluginAccessInfo).hoverTips;
        }
        log.showInfo('hoverTips = ' + hoverTips);

        if(hoverTips?.trim()) {
          this.hoverTipsContent = hoverTips;
        } else {
          this.getAppName();
        }
        break;
    }
  }

  private getShortcutText(pluginSlot: string): void {
    this.hoverTipsShortcutContent = (RTLUtil.isRTL() ? TIPS_MAP_RTL.get(pluginSlot) : TIPS_MAP.get(pluginSlot)) ?? '';
  }

  private async getInputMethodSubType(): Promise<string> {
    this.currentInputMethodSubtype = await InputMethodUtils.queryCurrentInputMethodSubtype();
    if (this.currentInputMethodSubtype && this.currentInputMethodSubtype.label) {
      return this.currentInputMethodSubtype.label;
    } else {
      return '';
    }
  }

  private async getInputMethod(): Promise<string> {
    this.currentInputMethod = await InputMethodUtils.queryCurrentInputMethod();
    if (this.currentInputMethod && this.currentInputMethod.label) {
      return this.currentInputMethod.label;
    } else {
      return '';
    }
  }

  private refreshSoundTipText(): void {
    if (this.pluginSlot !== PluginSlot.SLOT_STATUS_SOUND_PANEL) {
      return;
    }
    this.hoverTipsContent = this.getSoundPluginTips();
  }

  private getSoundPluginTips(): string {
    let deviceName: string = this.getDeviceNameByType(this.curDeviceType);
    log.showInfo(`soundVolume: ${this.volumePercentText}`);
    let tipString: string = ResUtils.getInnerStringByName('volume') +
      '(' + deviceName + '): ' + (RTLUtil.isRTL() ? '%' + this.volumePercentText : this.volumePercentText + '%');
    return tipString
  }

  private refreshMicrophoneTipText(): void {
    if (this.pluginSlot !== PluginSlot.SLOT_STATUS_MICROPHONE_PANEL) {
      return;
    }
    this.hoverTipsContent = this.getMircophonePluginTips();
  }

  private getMircophonePluginTips(): string {
    if (!this.microphonePanelCurrentEnable) {
      return ResUtils.getInnerStringByName('microphone_mute_enable');
    }
    if (!this.isPNREnable && !this.isAINREnable && !this.isReductNow) {
      return ResUtils.getInnerStringByName('microphone');
    }
    return ResUtils.getInnerStringByName('ai_sound_enable');
  }

  private getDeviceNameByType(audioDeviceType: number): string {
    switch (audioDeviceType) {
      case AudioDeviceType.EARPIECE:
        return ResUtils.getInnerStringByName('sound_device_earpiece');
      case AudioDeviceType.SPEAKER:
        return ResUtils.getInnerStringByName('sound_output_device_local');
      case AudioDeviceType.WIRED_HEADSET:
      case AudioDeviceType.WIRED_HEADPHONES:
      case AudioDeviceType.USB_HEADSET:
        return ResUtils.getInnerStringByName('sound_output_device_earphone');
      case AudioDeviceType.BLUETOOTH_SCO:
      case AudioDeviceType.BLUETOOTH_A2DP:
        return ResUtils.getInnerStringByName('sound_output_device_bluetooth');
      case AudioDeviceType.DISPLAY_PORT:
      case AudioDeviceType.REMOTE_CAST:
      case AudioDeviceType.HDMI:
        return ResUtils.getInnerStringByName('sound_output_device_display_port');
      case AudioDeviceType.USB_DEVICE:
      case AudioDeviceType.DEFAULT:
        return ResUtils.getInnerStringByName('sound_output_device_default');
      default:
        log.showError(`unknown type: ${JSON.stringify(audioDeviceType)}`);
        return ResUtils.getInnerStringByName('sound_output_device_default');
    }
  }

  private getWLANPluginTips(): string {
    let sharedNetworkTips: string = pluginDistributedController.getSharedNetworkTips();
    if (sharedNetworkTips !== '') {
      return sharedNetworkTips;
    }
    // 以太网
    if (!CheckEmptyUtils.isEmpty(this.ethernetTipString)) {
      return this.ethernetTipString;
    }
    // wlan
    let wlanTips: string = ResUtils.getInnerStringByName('wlan_closed');
    let wifiCurState: number = wifiManager.getWifiDetailState();
    if (wifiManager.isConnected() === false) {
      if (wifiCurState === 1 || wifiCurState === 2) {
        wlanTips = ResUtils.getInnerStringByName('wlan_disconnect');
      }
    } else {
      wlanTips = ResUtils.getInnerStringByName('wlan_connect');
    }
    log.showInfo(`getWLANPluginTips wifiCurState:${wifiCurState}, isConnected:${wifiManager.isConnected()}`);
    return wlanTips;
  }

  private getBatteryPluginTips(batteryPower: string): string {
    if (KeyboardBatteryMgr.getInstance().getShowKeyboardBattery(getContext(this) as common.UIAbilityContext) ==
        ChargingState.OFF) {
      return batteryPower;
    }
    if (KeyboardBatteryMgr.getInstance().getKeyboardConnectStatus()) {
      let keyboardBatteryPower: string = this.getKeyboardBatteryPluginTips();
      batteryPower += '\n' + keyboardBatteryPower;
    }
    return batteryPower;
  }

  private getKeyboardBatteryPluginTips(): string {
    let keyboardBatteryValue: number = KeyboardBatteryMgr.getInstance().getKeyboardBatteryValue();
    let keyboardBatteryPower: string =
      ResUtils.getInnerStringNumS($r('app.string.keyboard_battery_power'), `${keyboardBatteryValue}%`);
    if (KeyboardBatteryMgr.getInstance().getKeyboardBatteryChargingStatus()) {
      let keyboardBatteryChargingText: string =
        ResUtils.getInnerStringNumS($r('app.string.normal_charge'), `${keyboardBatteryValue}%`);
      if (keyboardBatteryValue === KEYBOARD_FULL_BATTERY) {
        keyboardBatteryChargingText =
          ResUtils.getInnerStringNumS($r('app.string.full_charge'), `${keyboardBatteryValue}%`);
      }
      keyboardBatteryPower =
        ResUtils.getInnerStringNumS($r('app.string.keyboard_battery_power'), `${keyboardBatteryChargingText}`);
    }
    return keyboardBatteryPower;
  }

  private getClockPluginTips(date: Date): string {
    this.is24HourFormat = this.get24HourFormat();
    this.mDay = this.formatDay(date);
    this.mTime = this.formatTime(date, this.is24HourFormat ? this.FORMAT_TIME_24H : this.FORMAT_TIME_12H);
    this.getWeek(date);
    log.showInfo('date is : ' + date.toString() + ' mTime is : ' + this.mTime);
    return this.mDay + ' ' + this.mWeek + ' ' + this.mTime;
  }

  get24HourFormat(): boolean {
    return i18n.System.is24HourClock();
  }

  /**
   * 格式化时间信息
   *
   * @param displayDate 当前日期
   * @param format 时间日期格式化对象
   * @returns 显示日期/时间
   */
  private formatTime(displayDate: Date, format: intl.DateTimeOptions): string {
    const date = new Date(displayDate);
    const locale = new intl.Locale(i18n.System.getSystemLanguage());
    const dateFormat = new intl.DateTimeFormat(locale.toString(), format);
    const dateStr: string = dateFormat.format(date);
    //存在内存泄漏，需要手动释放
    // MemoryUtils.removeNapiWrap(dateFormat, false);
    return dateStr;
  }

  formatDay(date: Date) {
    const locale = new intl.Locale(i18n.System.getSystemLanguage());
    const dateFormat = new intl.DateTimeFormat(locale.toString(), {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
    return dateFormat.format(date);
  }

  onLanguageChange(): void {
    this.language = AppStorage.get<string>('systemLanguage') as string;
    this.getWeek(this.date, true);
    this.getPluginText(this.pluginSlot);
    this.getShortcutText(this.pluginSlot);
  }

  getWeek(date: Date, needUpdate: boolean = false): void {
    if (!needUpdate && this.weekDay === date.getDay()) {
      return;
    }
    this.weekDay = date.getDay();
    const zhFlag = this.language.indexOf('zh') >= 0;
    const language: string = i18n.System.getSystemLanguage();
    const dateFormat = new Intl.DateTimeFormat(language, { weekday: zhFlag ? 'long' : 'short' });
    this.mWeek = dateFormat.format(date);
  }

  private getHoverTipsTextWidth(name: string): number | string {
    let width: number | string = Constants.POPUP_MIN_TEXT_WIDTH;
    if (CheckEmptyUtils.checkStrIsEmpty(name)) {
      return width;
    }
    const maxWidth: number = this.screenWidth * 2 / 3;
    width = this.getTextWidth(name, width, maxWidth);
    return width;
  }

  private getTextWidth(appName: string, width: number, maxWidth: number): number {
    let needTextWidth: number = Math.round(px2vp(measure.measureText({
      textContent: appName,
      fontSize: $r(Constants.PC_HOVER_TIPS_TEXT),
      fontWeight: FontWeight.Regular,
      overflow: TextOverflow.Ellipsis,
      maxLines: 1
    }))) + StyleConstants.DEFAULT_16;
    needTextWidth = needTextWidth > maxWidth ? maxWidth : needTextWidth;
    return needTextWidth > width ? needTextWidth : width;
  }

  private getHoverTipsTextHeight(name: ResourceStr): number | string {
    let height: number | string = StyleConstants.POPUP_TEXT_HEIGHT;
    if (typeof name === 'string' && CheckEmptyUtils.checkStrIsEmpty(name)) {
      return height;
    }
    const maxHeight: number = this.screenHeight * 2 / 3;
    height = this.getTextHeight(name, height, maxHeight);
    return height;
  }

  private getTextHeight(appName: ResourceStr, height: number, maxHeight: number): number {
    let needTextHeight: number = Math.round(px2vp(measure.measureText({
      textContent: appName,
      fontSize: $r(Constants.PC_HOVER_TIPS_TEXT),
      fontWeight: FontWeight.Regular,
      overflow: TextOverflow.Ellipsis,
      maxLines: 1
    }))) + StyleConstants.DEFAULT_16;
    needTextHeight = needTextHeight > maxHeight ? maxHeight : needTextHeight;
    return needTextHeight > height ? needTextHeight : height;
  }

  build() {
    Row() {
      Text(this.hoverTipsContent)
        .draggable(false)
        .id(`StatusBarPluginForPC_Text_${this.pluginSlot}`)
        .fontSize($r(Constants.PC_HOVER_TIPS_TEXT))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Start)
        .maxLines(2)
        .align(Alignment.Center)

      if (this.pluginSlot === PluginSlot.SLOT_STATUS_SMART_SCREENSHOT) {
        Image($r('app.media.shortcut_system_key'))
          .width('20vp')
          .height('20vp')
          .objectFit(ImageFit.Contain)
          .focusable(false)
          .draggable(false)
          .margin({ start: LengthMetrics.resource($r('sys.float.padding_level4')) })
      }

      if (this.hoverTipsShortcutContent !== '') {
        Text(this.hoverTipsShortcutContent)
          .draggable(false)
          .fontSize($r(Constants.PC_HOVER_TIPS_TEXT))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontWeight(FontWeight.Regular)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(RTLUtil.isRTL() ? TextAlign.End : TextAlign.Start)
          .maxLines(1)
          .align(Alignment.Center)
      }
    }
    .justifyContent(FlexAlign.Center)
    .padding({ top: TIPS_TEXT_PADDING })
    .margin($r('sys.float.padding_level4'))
  }
}