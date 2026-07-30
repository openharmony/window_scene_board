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
import {
  GlobalContext,
  PluginClickInfo,
  EventManager,
  EvtBus,
  EventConstants,
  DeviceHelper,
  sEventManager,
  obtainLocalEvent,
  PluginSlot,
  PluginPosition,
  sSettingsUtil,
} from '@ohos/frameworkwrapper';
import {
  FASlotName,
  SettingsConstants,
  SettingsKeyConstants,
} from '@ohos/commonconstants';
import lazy { windowMgr } from '@ohos/windowscene/src/main/ets/windowmanager/WindowManagerProxy';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import Want from '@ohos.app.ability.Want';
import rpc from '@ohos.rpc';
import Constants, { FocusModeData } from '../common/Constants';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { DataShareUtils, StatusBarType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { FocusModeSwitchDataEvent } from '@ohos/systemuicommon/src/main/ets/datasharemanager/SysUIDataShareEvent';
import {
  WindowPositionChangeEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';
import { ToggleStyle, ToggleScene } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { ModeChangeUtils } from '@ohos/frameworkwrapper/src/main/ets/utils/ModeChangeUtils';

const TAG: string = 'Model.FocusModeToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const SET_ZEN_MODE_OPEN: string = 'setZenModeOpen';
const SET_ZEN_MODE_OFF: string = 'setZenModeOff';
const FOCUS_MODE_ID: string = '1';
const SET_ZEN_MODE: number = 6;
const SET_ZEN_SCENARIO_MODE: number = 2;
const LOCAL_EVENT_TYPE: string = 'local';
const SET_MODE_DELAY: number = 300;
const UN_CHECKED: string = '0';
const CHECKED: string = '1';
const INTELLIGENT_SCENE_ENABLE_REMINDER_FLAG: string = 'intelligent_scene_reminder_flag';

export class FocusModeToggleController extends ToggleBaseViewModel {
  private mFocusModeData: FocusModeData = new FocusModeData();
  private focusModeToggleEventMgr: EventManager = EvtBus.createEventManager();
  private connectId: number = -1;
  private proxy: rpc.IRemoteObject | undefined | null = null;
  private scenarioProxy: rpc.IRemoteObject | undefined | null = null;
  private disconnectTimeoutId: number = -1;
  private isLockScenarioMode: boolean = false;
  private isIntelligentSceneEnable: boolean = AppStorage.get<boolean>('IntelligentSceneEnable') ?? false;

  public openDetailPageFunc: (() => void) | undefined = () => {
    if (DeviceHelper.isPC()) {
      if (this.isIntelligentSceneEnable) {
        return;
      }
      this.handleLongClickPc();
    } else {
      this.handleOnControlCenterWithScreenLockForUIE((): void => this.openFocusModeSubPanel(), true);
    }
  }

  constructor() {
    super();
    this.getViewData().isSymbolIcon = true;
    this.getViewData().icon = $r('sys.symbol.moon');
    this.getViewData().label = $r('app.string.control_center_complex_toggle_focus_mode_title');
    this.onStart();
  }

  isPersist(): boolean {
    return true;
  }

  public static getInstance(): FocusModeToggleController {
    let controller: FocusModeToggleController = SingletonHelper.getInstance(FocusModeToggleController, TAG);
    return controller;
  }

  isLoadLottie(): boolean {
    return true;
  }

  isDarkReverse(): boolean {
    return true;
  }

  decorateStyle(style: ToggleStyle, scene?: ToggleScene | undefined): ToggleStyle | undefined {
    if (scene === ToggleScene.PC) {
      style.toggleParam?.labelArrow(!this.isIntelligentSceneEnable);
    }
    return style;
  }

  getLottieOpenDarkName(): string {
    return Constants.LOTTIE_DATA_OPEN_DARK;
  }

  getLottieCloseDarkName(): string {
    return Constants.LOTTIE_DATA_CLOSE_DARK;
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart')

    // 初始化开关状态
    this.initFocusModeState();

    // 监听注册监听
    this.registerEvents();
  }

  private onFocusModeSwitchDataChange = (event: FocusModeSwitchDataEvent): void => {
    const isEnable: boolean = event.isFocusModeSwitchEnable();
    log.showInfo('onFocusModeSwitchDataChange isEnable: ' + isEnable);
    if (this.getViewData().isOn !== isEnable) {
      this.getViewData().isOn = isEnable;
    }
  };

  private onFocusModeProfileDataChange = (): void => {
    let focusModeProfile: string =
      DataShareUtils.getSettingsSecureValueSync(SettingsKeyConstants.FOCUS_MODE_PROFILE_URI, '0');
    log.showInfo(`onFocusModeSwitchDataChange focusModeProfile: ${focusModeProfile}`);
    let isEnableFocusMode = focusModeProfile === FOCUS_MODE_ID;
    if (this.getViewData().isOn !== isEnableFocusMode) {
      this.getViewData().isOn = isEnableFocusMode;
    }
  }

  initFocusModeState() {
    // 数据库开关状态获取
    if (this.isIntelligentSceneEnable) {
      this.getViewData().isOn = DataShareUtils.getSettingsSecureValueSync(SettingsKeyConstants.FOCUS_MODE_PROFILE_URI,
        SettingsConstants.FOCUS_MODE_ENABLE_DEFAULT) === FOCUS_MODE_ID;
    } else {
      this.getViewData().isOn = DataShareUtils.getSettingsSecureValueSync(SettingsKeyConstants.FOCUS_MODE_ENABLE,
        SettingsConstants.FOCUS_MODE_ENABLE_DEFAULT) !== SettingsConstants.FOCUS_MODE_ENABLE_DEFAULT;
    }
    const dndCount: number = Number(sSettingsUtil.getSystemValue(Constants.DND_COUNT, '0'));
    this.mFocusModeData.isShowDialog = (!isNaN(dndCount) && dndCount < Constants.DND_DISABLE_DIALOG_COUNT);
    log.showInfo('onstart FocusModeSwitchData data: ' + this.getViewData().isOn);
  }

  async registerEvents() {
    this.focusModeToggleEventMgr.on(FocusModeSwitchDataEvent, this.isIntelligentSceneEnable ?
      this.onFocusModeProfileDataChange : this.onFocusModeSwitchDataChange);
    sEventManager.subscribe(EventConstants.CONTROL_CENTER_SHOW_HIDE_BAR, (event: boolean) => {
      if (this.proxy && event) {
        this.destroy();
      }
    });
  }

  onStop(): void {
    log.showInfo('onStop');
    this.focusModeToggleEventMgr.offAll();
  }

  isAvailable(): boolean {
    return true;
  }


  handleOneClick(): void {
    log.showInfo(`handleClick start old status: ${this.getViewData().isOn}`);
    if (!this.getViewData().isOn) {
      this.updateDialogStatus();
    }
    // 模拟器场景走免打扰逻辑
    if (DeviceHelper.isPC() || DeviceHelper.isEmulator()) {
      if (this.isIntelligentSceneEnable) {
        this.lockClickScenarioMode();
      } else {
        this.onQsPanelClickForPC(this.getNextStatus());
      }
    } else {
      this.handleOnControlCenterWithScreenLockForUIE((): void => {
        this.lockClickScenarioMode();
      });
    }
  }

  private lockClickScenarioMode(): void {
    if (this.isLockScenarioMode) {
      return;
    } else {
      setTimeout(() => {
        log.showInfo('Timeout,  reset scenario mode status');
        this.isLockScenarioMode = false;
      }, SET_MODE_DELAY);
      this.isLockScenarioMode = true;
      this.handleUpdateState();
      this.onQsPanelClick();
    }
  }

  private onQsPanelClickForPC(isOpen: boolean): void {
    sSettingsUtil.setSecureValue('focus_mode_enable', isOpen ? '1' : '0');
    sSettingsUtil.setSystemValue('focus_mode_manual_enable', isOpen ? '1' : '0');
    return;
  }

  private onQsPanelClick(): void {
    try {
      const option = new rpc.MessageOption();
      const data = new rpc.MessageSequence();
      const reply = new rpc.MessageSequence();
      const want: Want = {
        'bundleName': 'com.ohos.intelligentscene',
        'abilityName': 'IntelligentSceneServiceExtAbility'
      };
      const callMessage: CallMessage = { method: 'modeManualEnable', extra: { modeId: FOCUS_MODE_ID, openType: '1' } };
      const options: common.ConnectOptions = {
        onConnect: (elementName, proxy) => {
          log.showInfo(`onConnect ${elementName}`);
          this.proxy = proxy;
          data.writeInterfaceToken(proxy.getDescriptor());
          data.writeString(JSON.stringify(callMessage));
          proxy.sendMessageRequest(SET_ZEN_SCENARIO_MODE, data, reply, option).then(() => {
            if (this.isCheckedRemind()) {
              this.destroy();
            }
          });
        },
        onDisconnect: (elementName) => {
          log.showInfo(`onDisconnect ${elementName}`);
          data.reclaim();
          reply.reclaim();
        },
        onFailed: (code) => {
          log.showInfo(`IDL Connect onFailed ${code}`);
          data.reclaim();
          reply.reclaim();
        }
      }

      if (this.proxy) {
        data.writeInterfaceToken(this.proxy.getDescriptor());
        data.writeString(JSON.stringify(callMessage));
        this.proxy.sendMessageRequest(SET_ZEN_SCENARIO_MODE, data, reply, option);
      } else {
        this.connectId = GlobalContext.getContext().connectServiceExtensionAbility(want, options);
      }
      log.showInfo(`connectId is: ${this.connectId}`);
    } catch (error) {
      log.showError('handleClick error', error);
    }
  }

  private updateDialogStatus(): void {
    log.showInfo(`Enable focus mode isShowDialog: ${this.mFocusModeData.isShowDialog}`);
    if (!this.mFocusModeData.isShowDialog) {
      return;
    }
    const dndCount: number = Number(sSettingsUtil.getSystemValue(Constants.DND_COUNT, '0'));
    this.mFocusModeData.isShowDialog = (!isNaN(dndCount) && dndCount < Constants.DND_DISABLE_DIALOG_COUNT);
  }

  private getNextStatus(): boolean {
    // 有弹窗提示时不执行 UI First 逻辑
    if (this.getViewData().isOn) {
      this.getViewData().isOn = !this.getViewData().isOn;
      return false;
    }
    if (!this.mFocusModeData.isShowDialog) {
      this.getViewData().isOn = !this.getViewData().isOn;
    }
    return true;
  }

  handleUpdateState(): void {
    // 无弹窗时执行 UI First 逻辑
    if (this.getViewData().isOn || this.isCheckedRemind()) {
      this.getViewData().isOn = !this.getViewData().isOn;
    }
  }

  /**
   * 是否有情景模式弹窗提醒
   */
  private isCheckedRemind(): boolean {
    const remindFlag =
      DataShareUtils.getSettingsSecureValueSync(INTELLIGENT_SCENE_ENABLE_REMINDER_FLAG, UN_CHECKED);
    log.showInfo('remindFlag: ' + remindFlag);
    return remindFlag === CHECKED;
  }

  destroy(): void {
    try {
      GlobalContext.getContext().disconnectServiceExtensionAbility(this.connectId).then(() => {
        this.proxy = null;
        log.showInfo(`disconnect ${this.connectId} successd.`);
      }).catch((error: BusinessError) => {
        log.showError(`disconnect failed. Error code: ${error.code}`);
      });
    } catch (err) {
      log.showError(`destroy connection finally failed: ${err}`);
    }
  }

  private handleLongClickPc(): void {
    if (this.isIntelligentSceneEnable) {
      return;
    }
    // pc点击文字弹出二级窗口，并关闭控制中心面板
    sEventManager.publish(obtainLocalEvent(LOCAL_EVENT_TYPE, false));
    windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
    // 设置二级页面窗口位置
    let position = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_FOCUS_MODE_PADDLE);
    if (StatusBarType.isMacStyle(AppStorage.get('statusBarType') as number)) {
      let controlCenterPosition = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
      position.left = controlCenterPosition.left + controlCenterPosition.width - position.width;
    }
    EvtBus.post(WindowPositionChangeEvent,
      { windowName: PluginSlot.SLOT_STATUS_FOCUS_MODE_PADDLE,
        position: PluginPosition.POSITION_RIGHT, area: position,
        caller: PluginSlot.SLOT_STATUS_CONTROL_CENTER});
    windowMgr.showWindowWithAnim(PluginSlot.SLOT_STATUS_FOCUS_MODE_PADDLE, true);
    sEventManager.publish(obtainLocalEvent(LOCAL_EVENT_TYPE, true));
  }

  openFocusModeSubPanel(): void {
    log.showInfo('show focus mode subpage');
    sToggleSubWindowController.showSubWindowByClickInfo(FASlotName.FOCUS_MODE, {
      clickType: 'window',
      bundleName: 'com.ohos.settings',
      abilityName: 'NotDisturbUIExtensionSettingsAbility',
      uiExtensionType: 'sys/commonUI',
      windowHeight: 413
    } as PluginClickInfo);
  }

  getData(): FocusModeData {
    return this.mFocusModeData;
  }
}

export interface CallMessage {
  method: string;
  extra?: ModeManualEnableParam;
}

export interface ModeManualEnableParam {
  modeId: string,
  openType?: string,
}