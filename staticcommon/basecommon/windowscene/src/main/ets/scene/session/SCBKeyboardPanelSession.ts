/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import keyboardPanelManager from '@ohos.keyboardPanelManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { SCBSystemSceneSession, SystemSessionInfo, SystemSessionChangeCallback } from './SCBSystemSceneSession';
import { SCBKeyboardManager } from './SCBKeyboardManager';
import { SCBScreenSessionManager } from '../../screen/session/SCBScreenSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBKeyboardPanelManager } from './SCBKeyboardPanelManager';
import { SCBSceneSessionManager, INVALID_SCREEN_ID } from './SCBSceneSessionManager';
import { DeviceHelper, ResourceManager } from '@ohos/frameworkwrapper';
import { PanelFlag } from '@kit.IMEKit';
import { image } from '@kit.ImageKit';

const TAG = 'SCBKeyboardPanelSession';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export enum KEYBOARD_PRIVATE_COMMAND_KEYS {
  PATTERN_ACTION = 'patternOption',
  TOOLBAR_PADDING_LEFT = 'toolbarPaddingLeft',
  TOOLBAR_PADDING_RIGHT = 'toolbarPaddingRight',
  FK_COLOR = 'functionKeyColor',
  FK_PRESS_COLOR = 'functionKeyPressColor',
  SMART_TYPE = 'smartType',
  CMD_FLOW_LIGHT_PAUSE = 'flowLightPause'
}

export interface SmartMenuItem {
  name: string;
  normalIcon?: string;
  selectedIcon?: string;
  actionType: string;
  actionParams: MenuAction;
  isDefault: boolean;
}

export interface MenuAction {
  subType?: string;
  abilityName?: string;
  module?: string;
  uri?: string;
  parameters?: Parameters;
}

export interface Parameters {
  key: string;
  value: string;
}

export interface SmartMenu {
  smartMenuList: Array<SmartMenuItem>;
  newSmartMenuList?: NewSmartMenu;
}

interface NewSmartMenu {
  float: Array<SmartMenuItem>;
  portrait: Array<SmartMenuItem>;
  landscape: Array<SmartMenuItem>;
  ultraScreenGState: Array<SmartMenuItem>;
}

interface SmartButtonInfo {
  smartButton: SmartMenuItem;
}

export enum PatternAction {
  NORMAL = 0,
  THUMB,
  FLOATING,
  ONE_HAND,
}

enum InputType {
    NONE = -1,
    CAMERA_INPUT = 0,
    SECURITY_INPUT = 1,
    VOICE_INPUT = 2,
    VOICEKB_INPUT = 3
  }

/**
 * Session of keyboard panel
 *
 */
@Observed
export class SCBKeyboardPanelSession extends SCBSystemSceneSession {
  public smartButtonInfo: SmartButtonInfo | undefined;
  public rightIcon: string | image.PixelMap = '';
  public rightSelectedIcon: string | image.PixelMap = '';
  public toolbarPaddingLeft: number = 0;
  public toolbarPaddingRight: number = 0;
  public functionKeyColor: string = '';
  public functionKeyPressColor: string = '';
  public isShowPanel: boolean = false;
  public hotAreaBottom: number = 0;
  public isLandscape: boolean = false;
  public isExpandStatus: boolean = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
  public keyboardViewMode: sceneSessionManager.KeyboardViewMode = 
    sceneSessionManager?.KeyboardViewMode?.NON_IMMERSIVE_MODE;
  public isFlowLightMode: boolean = false;
  public isGradientMode: boolean = false;
  public blurHeight: number = 0;
  public isPanelBarShow: boolean = true;
  private isHotSwitch: boolean = false;
  private smartMenu: SmartMenu;
  private patternOption: number = 0;
  private panelAdjustHeight: number = 0;
  private panelRealHeight: number = -1;
  private systemCmdConnected: boolean = false;
  private bundleChangeEvent: commonEventManager.CommonEventSubscriber | undefined = undefined;
  public smartKeys: string[] = [];

  constructor(session: sceneSessionManager.SceneSession, systemSessionInfo: SystemSessionInfo,
              sessionChangeCallback?: SystemSessionChangeCallback) {
    super(session, systemSessionInfo, sessionChangeCallback);
  }

  public getPanelRealHeight(): number {
    return this.panelRealHeight < 0 ? this.panelAdjustHeight : this.panelRealHeight;
  }

  public setPanelRealHeight(panelHeight: number): void {
    this.panelRealHeight = panelHeight;
  }

  public getPatternOption(): PatternAction {
    let keyboardGravity = SCBKeyboardManager.getInstance().getKeyboardSession()?.sessionGravity;
    if (keyboardGravity === sceneSessionManager.KeyboardGravity.GRAVITY_FLOAT) {
      return PatternAction.FLOATING;
    }
    return this.patternOption;
  }

  /**
   * @description: set panel adjust height
   *
   * @returns 
   */
  public setPanelAdjustHeight(panelAdjustHeight: number): void {
    this.panelAdjustHeight = panelAdjustHeight;
  }

  /**
   * @description: registe keyboard panel listener
   *
   * @returns
   */
  public registerListener(): void {
    this.systemCmdConnected = false;
    this.connectSystemCmd();
    this.destroyKeyboardPanelListener();
    this.registerPrivateCommandChannel();
    this.registerPanelIsShowChange();
    this.getSmartMenuCfg();
    this.isLandscape = DeviceHelper.isLandscape();
    this.subscribeToPackageChange();
  }

  /**
   * @description: connect system cmd channel
   *
   * @returns
   */
  public connectSystemCmd(): void {
    if (this.systemCmdConnected === false) {
      log.showInfo(`connectSystemCmd systemCmdConnected =  ${this.systemCmdConnected}`);
      keyboardPanelManager.connectSystemCmd().then(()=>{
        this.systemCmdConnected = true;
      }).catch((error: BusinessError) => {
        this.systemCmdConnected = false;
        log.showError(`connectSystemCmd error =  ${error.code}, message = ${error.message}`);
      });
    }
  }

  /**
   * @description: get smart menu list
   *
   * @returns Array<SmartMenuItem>
   */
  public getSmartMenuList(gravity: sceneSessionManager.KeyboardGravity): Array<SmartMenuItem> {
    if (this.smartMenu.newSmartMenuList) {
      if (gravity === sceneSessionManager.KeyboardGravity.GRAVITY_FLOAT) {
        return this.smartMenu.newSmartMenuList.float;
      }
      if (DeviceHelper.isUltraScreenProduct() && DeviceHelper.isGState()) {
        return this.smartMenu.newSmartMenuList.ultraScreenGState;
      }
      if (this.isExpandStatus) {
        return this.smartMenu.newSmartMenuList.portrait;
      }
      return this.isLandscape ? this.smartMenu.newSmartMenuList.landscape : this.smartMenu.newSmartMenuList.portrait;
    }
    return this.smartMenu.smartMenuList;
  }

  public getSmartMenu(): SmartMenu {
    return this.smartMenu;
  }

  public getIsHotSwitch(): boolean {
    return this.isHotSwitch;
  }

  public setHotSwitch(hotSwitch: boolean): void {
    this.isHotSwitch = hotSwitch;
  }

  public setVisibility(visibility: boolean): void {
    super.setVisibility(visibility);
    SCBKeyboardPanelManager.getInstance().setPanelDialogShow(false);
  }

  public resetPanelBar(): void {
    this.toolbarPaddingLeft = 0;
    this.toolbarPaddingRight = 0;
  }

  /**
   * @description: reset function key color
   *
   * @returns 
   */
  public resetFunctionKeyColor(): void {
    this.functionKeyColor = '';
    this.functionKeyPressColor = '';
  }
  
  private addSmartKey(item: SmartMenuItem):void {
    if (item.isDefault) {
      return;
    }
    if (item.actionType === 'subType') {
      if (item.actionParams?.subType && (this.smartKeys.indexOf(item.actionParams?.subType) === -1)) {
        this.smartKeys.push(item.actionParams?.subType);
      }
    } else {
      if (item.actionParams?.parameters?.key &&
        (this.smartKeys.indexOf(item.actionParams?.parameters?.key) === -1)) {
        this.smartKeys.push(item.actionParams?.parameters?.key);
      }
    }
  }

  private refreshSmartList(): void {
    this.smartKeys = [];
    if (this.smartMenu?.newSmartMenuList) {
      this.smartMenu?.newSmartMenuList.float.filter((item: SmartMenuItem) => {
        this.addSmartKey(item);
        return !item.isDefault;
      });
      this.smartMenu?.newSmartMenuList.portrait.filter((item: SmartMenuItem) => {
        this.addSmartKey(item);
        return !item.isDefault;
      });
      this.smartMenu?.newSmartMenuList.landscape.filter((item: SmartMenuItem) => {
        this.addSmartKey(item);
        return !item.isDefault;
      });
      this.smartMenu?.newSmartMenuList.ultraScreenGState.filter((item: SmartMenuItem) => {
        this.addSmartKey(item);
        return !item.isDefault;
      });
    }
    let smartList: SmartMenuItem[] = [];
    this.smartMenu?.smartMenuList?.forEach((item: SmartMenuItem) => {
      if (!item.isDefault) {
        smartList.push(item);
        this.addSmartKey(item);
      } else {
        this.smartButtonInfo = {
          smartButton : item
        };
      }
    });
    this.smartMenu.smartMenuList = smartList;
    SCBKeyboardPanelManager.getInstance().resetSmartMode(this.smartKeys);
  }

  public async getSmartButton(): Promise<void> {
    if (this.smartButtonInfo?.smartButton === undefined || this.smartButtonInfo?.smartButton === null) {
      await this.getSmartMenuCfg();
    }
  }

  public sendPrivateCommand(patternOption: PatternAction): void {
    if (patternOption !== PatternAction.FLOATING) {
      this.patternOption = patternOption;
    }
    AppStorage.SetOrCreate('patternOption', this.patternOption);
    let privateCommand: Record<string, keyboardPanelManager.CommandDataType> = {
      'sys_cmd': 1,
      'patternOption': patternOption
    };
    try {
      keyboardPanelManager.sendPrivateCommand(privateCommand);
    } catch (err) {
      log.showError('sendPrivateCommand error = ' + JSON.stringify(err));
    }
  }

  private setPatternOption(paddingLeft: number, paddingRight: number): void {
    if (paddingLeft === paddingRight && !SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()) {
      this.patternOption = PatternAction.NORMAL;
      AppStorage.setOrCreate('patternOption', this.patternOption);
    }
  }  
  
  private registerPrivateCommandChannel(): void {
    try {
      keyboardPanelManager.on('panelPrivateCommand',
        (privateCommand: Record<string, keyboardPanelManager.CommandDataType>) => {
          log.showInfo('privateCommandCallback' + JSON.stringify(privateCommand));
          let patternOption = privateCommand[KEYBOARD_PRIVATE_COMMAND_KEYS.PATTERN_ACTION] as number;
          if ((typeof patternOption === 'number') && patternOption >= PatternAction.NORMAL &&
            patternOption <= PatternAction.ONE_HAND) {
            this.patternOption = patternOption;
            AppStorage.setOrCreate('patternOption', this.patternOption);
          }
          let paddingLeft = privateCommand[KEYBOARD_PRIVATE_COMMAND_KEYS.TOOLBAR_PADDING_LEFT] as number;
          let paddingRight = privateCommand[KEYBOARD_PRIVATE_COMMAND_KEYS.TOOLBAR_PADDING_RIGHT] as number;
          if (paddingLeft >= 0 && paddingRight >= 0) {
            this.toolbarPaddingLeft = paddingLeft;
            this.toolbarPaddingRight = paddingRight;
            this.setPatternOption(paddingLeft, paddingRight);
          }
          this.smartKeys.forEach((item: string) => {
            this.matchSmartTypeKey(privateCommand, item);
          });
          if (!privateCommand) {
            log.showError('privateCommand is null');
            return;
          }
          if (Object.prototype.hasOwnProperty.call(privateCommand, KEYBOARD_PRIVATE_COMMAND_KEYS.FK_COLOR)) {
            this.functionKeyColor = privateCommand[KEYBOARD_PRIVATE_COMMAND_KEYS.FK_COLOR] as string;
          }
          if (Object.prototype.hasOwnProperty.call(privateCommand, KEYBOARD_PRIVATE_COMMAND_KEYS.FK_PRESS_COLOR)) {
            this.functionKeyPressColor = privateCommand[KEYBOARD_PRIVATE_COMMAND_KEYS.FK_PRESS_COLOR] as string;
          }
          if (Object.prototype.hasOwnProperty.call(privateCommand,
            KEYBOARD_PRIVATE_COMMAND_KEYS.CMD_FLOW_LIGHT_PAUSE)) {
              let isFlowLightPause = privateCommand[KEYBOARD_PRIVATE_COMMAND_KEYS.CMD_FLOW_LIGHT_PAUSE] as boolean;
              SCBKeyboardPanelManager.getInstance().pauseFlowLight(isFlowLightPause);
          }
        });
    } catch (err) {
      log.showError('on panelPrivateCommand error, ' + JSON.stringify(err));
    }
  }

  private matchSmartTypeKey(privateCommand: Record<string, keyboardPanelManager.CommandDataType>, key: string): void {
    let smartTypeValue = privateCommand[key] as string;
    if (smartTypeValue && smartTypeValue === 'open') {
      SCBKeyboardPanelManager.getInstance().setSmartMode(key, true);
    } else if (smartTypeValue === 'exit') {
      SCBKeyboardPanelManager.getInstance().setSmartMode(key, false);
    }
  }

  private registerPanelIsShowChange(): void {
    try {
      keyboardPanelManager.on('isPanelShow', (panelStatus: keyboardPanelManager.SysPanelStatus) => {
        if (panelStatus === null || panelStatus === undefined || DeviceHelper.isPad() ||
          SCBSceneSessionManager.getInstance().mainScreenId === INVALID_SCREEN_ID) {
          return;
        }
        log.showInfo(`this.isShowPanel : ${this.isShowPanel}, panelStatus.inputType :${panelStatus.inputType},` +
          `width: ${panelStatus.width}, height: ${panelStatus.height}, flag: ${panelStatus.flag}` + 
          `isMainDisplay: ${panelStatus.isPanelRaised}, needFuncButton: ${panelStatus.needFuncButton}`);
        let isShowPanel = panelStatus.inputType !== InputType.SECURITY_INPUT && panelStatus.isPanelRaised &&
          panelStatus.inputType !== InputType.VOICEKB_INPUT && panelStatus.inputType !== InputType.CAMERA_INPUT &&
          panelStatus.flag !== PanelFlag.FLAG_CANDIDATE;
        if (this.isShowPanel !== isShowPanel) {
          this.isShowPanel = isShowPanel;
        }
        this.isPanelBarShow = this.isShowPanel ? panelStatus.needFuncButton : false;
      });
    } catch (err) {
      log.showError('on isPanelShow error, ' + JSON.stringify(err));
    }
  }

  private async getSmartMenuCfg(): Promise<void> {
    let smartMenuInfo = await keyboardPanelManager.getSmartMenuCfg();
    if (smartMenuInfo) {
      this.smartMenu = JSON.parse(smartMenuInfo);
    }
    this.refreshSmartList();
    if (this.smartButtonInfo?.smartButton === undefined) {
      log.showError('smartButton is undefined.');
      return;
    }
    try {
      let defaultInputMethod: string = keyboardPanelManager.getDefaultInputMethod().name;
      if (!(this.smartButtonInfo?.smartButton?.selectedIcon && this.smartButtonInfo?.smartButton?.selectedIcon.split(':').length > 1)) { 
        log.showError('selectedIcon is null or selectedIcon.length > 1.');
        return;
      }
      let resId = this.smartButtonInfo?.smartButton?.selectedIcon.split(':')[1];
      if (this.rightIcon === '' || this.rightIcon === null) {
          ResourceManager.getInstance().getNormalMediaAppIconWithCache(parseInt(resId), defaultInputMethod, 'default',
            (icon: image.PixelMap) => { this.rightIcon = icon; }, '');
      }
      if (this.rightSelectedIcon === '' || this.rightSelectedIcon === null) {
          ResourceManager.getInstance().getNormalMediaAppIconWithCache(parseInt(resId), defaultInputMethod, 'default',
            (icon: image.PixelMap) => { this.rightSelectedIcon = icon; }, '');
      }
    } catch (error) {
      log.showError(`getNormalMediaAppIconWithCache failed, message: ${error.message}`);
    }
  }

  /**
   * destroy
   *
   * @returns 
   */
  private destroyKeyboardPanelListener(): void {
    this.unsubscribe();
    keyboardPanelManager.off('panelPrivateCommand');
    keyboardPanelManager.off('isPanelShow');
  }

  /**
   * 订阅包更新公共事件
   *
   * @returns 
   */
  private subscribeToPackageChange(): void {
    const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: ['usual.event.PACKAGE_CHANGED', 'usual.event.PACKAGE_ADDED']
    }
    try {
      commonEventManager.createSubscriber(subscribeInfo, (err, commonEventSubscriber: commonEventManager.CommonEventSubscriber) => {
        if (err) {
          log.showError(`Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
          return;
        }
        this.bundleChangeEvent = commonEventSubscriber;
        this.onEventSubscribed();
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      log.showError(`Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
    }
  }

  /**
   * 取消公共事件订阅
   *
   * @returns 
   */
  private unsubscribe(): void {
    try {
      commonEventManager.unsubscribe(this.bundleChangeEvent, (err: BusinessError) => {
        if (err) {
          console.error(`Failed to unsubscribe. Code is ${err.code}, message is ${err.message}`);
          return;
        }
        // subscriber不再使用时需要将其置为undefined，避免内存泄露
        this.bundleChangeEvent = undefined;
        console.info(`Succeeded in unsubscribing.`);
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`Failed to unsubscribe. Code is ${err.code}, message is ${err.message}`);
    }
  }

  /**
   * on event subscribed
   *
   * @returns 
   */
  private onEventSubscribed(): void {
    try {
      commonEventManager.subscribe(this.bundleChangeEvent, (err, commonEvent: commonEventManager.CommonEventData) => {
        if (err) {
          log.showError(`Failed to subscribe. Code is ${err.code}, message is ${err.message}`);
          return;
        }
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      log.showError(`Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
    }
  }
}
