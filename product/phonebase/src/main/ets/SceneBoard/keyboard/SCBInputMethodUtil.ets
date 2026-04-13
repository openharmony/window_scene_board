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

import accessibility from '@ohos.accessibility';
import systemParameter from '@ohos.systemParameterEnhance';
import settings from '@ohos.settings';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBKeyboardManager, SCBKeyboardPanelManager, SCBOobeManager, SCBSceneSessionManager } from '@ohos/windowscene';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { inputMethod, InputMethodSubtype } from '@kit.IMEKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { uiEffect } from '@kit.ArkGraphics2D';

const TAG: string = 'SCBIMFInputMethodUtil';
const ENABLE_IME: string = 'settings.inputmethod.enable_ime';
const PERSIST_SYS_FONT_SIZE_SCALE: string = 'persist.sys.font_scale_for_user0';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const MAX_FONT_SCALE: number = 1.625;
const PRESSED_EFFECT_COLOR: Resource = $r('sys.color.interactive_pressed');
const FONT_AND_ICON_COLOR: Resource = $r('sys.color.font_primary');
const SPLIT_LINE_COLOR: Resource = $r('sys.color.ohos_id_color_list_separator');
const NOT_SELECT_COLOR: Resource = $r('sys.color.icon_secondary');
const PANEL_IMAGE_COLOR: number[] = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.9, 0 ];;
const PANEL_IMAGE_COLOR_WHITE: number[] = [0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0.9, 0];
const PANEL_DARK_BLENDER: uiEffect.BrightnessBlender = uiEffect.createBrightnessBlender({
  cubicRate: 0, quadraticRate: 0, linearRate: 0.2668, degree: 0.1674, saturation: 1.8,
  positiveCoefficient: [1.8, 2.3, 1.2], negativeCoefficient: [1, 2, 1], fraction: 0
});
const PANEL_LIGHT_BLENDER: uiEffect.BrightnessBlender = uiEffect.createBrightnessBlender({
  cubicRate: 0, quadraticRate: 0, linearRate: 0.0253, degree: 0.8814, saturation: 2,
  positiveCoefficient: [7, 15, 13], negativeCoefficient: [11, 15, 2], fraction: 0
});
const IMAGE_DARK_BLENDER: uiEffect.BrightnessBlender = uiEffect.createBrightnessBlender({
  cubicRate: 0, quadraticRate: 0, linearRate: 0.1239, degree: 0.9, saturation: 2,
  positiveCoefficient: [1.6, 3, 1.5], negativeCoefficient: [1.2, 1.2, 1], fraction: 0
});
const IMAGE_FLOWLIGHT_DARK_BLENDER: uiEffect.BrightnessBlender = uiEffect.createBrightnessBlender({
  cubicRate: 0, quadraticRate: 0, linearRate: 1, degree: 0.55, saturation: 1.2,
  positiveCoefficient: [1, 2, 1], negativeCoefficient: [0.5, 1, 0.5], fraction: 0
});
const IMAGE_LIGHT_BLENDER: uiEffect.BrightnessBlender = uiEffect.createBrightnessBlender({
  cubicRate: 0, quadraticRate: 0, linearRate: 0.4, degree: -0.0980, saturation: 1.5,
  positiveCoefficient: [1.5, 3.8, 1.3], negativeCoefficient: [0.5, 0.67, 1.3], fraction: 0
});

const IMAGE_FLOWLIGHT_LIGHT_BLENDER: uiEffect.BrightnessBlender = uiEffect.createBrightnessBlender({
  cubicRate: 0, quadraticRate: 0, linearRate: 1, degree: -0.8, saturation: 1.5,
  positiveCoefficient: [1.5, 3.8, 1.3], negativeCoefficient: [0.5, 0.67, 1.3], fraction: 0
});

const NONE_BLENDER: uiEffect.BrightnessBlender = uiEffect.createBrightnessBlender({
  cubicRate: 0, quadraticRate: 0, linearRate: 1, degree: 0, saturation: 1,
  positiveCoefficient: [0, 0, 0], negativeCoefficient: [0, 0, 0], fraction: 1
});
const BACK_GROUND_LIGHT_EFFECT: BackgroundEffectOptions	= {
  radius: 60, policy: 1, saturation: 1.9, color: $r('app.color.keyboard_light_Dialog_color')
};
const BACK_GROUND_DARK_EFFECT: BackgroundEffectOptions	= {
  radius: 60, policy: 1, saturation: 1.5, color: $r('app.color.keyboard_dark_Dialog_color')
};

export interface SubType {
  name: string;
  id: string;
  isCurrent: boolean;
}

class SCBInputMethodUtil {
  public activeSubtypes: InputMethodSubtype[] = [];
  public currentSubtypeIndex: number = -1;
  public settingsSubType: Array<SubType> = [];
  public inputMethodList: Array<inputMethod.InputMethodProperty> = [];
  public currentInputMethodName: string = '';
  public currentSubTypeId: string = ''; 
  public defaultInputMethod: inputMethod.InputMethodProperty;

  constructor() {
    this.defaultInputMethod = inputMethod.getDefaultInputMethod();
    this.initData();
    // 注册监听
    try {
      settings.registerKeyObserver(GlobalContext.getContext(), settings.input.ACTIVATED_INPUT_METHOD_SUB_MODE,
        settings.domainName.USER_PROPERTY, () => {
          this.initEnabledSubTypes();
        });
    } catch (err) {
      let error = err as BusinessError;
      log.showError(`constructor registerKeyObserver failed, message: ${error.message}, code: ${error.code}`);
    }
  }

  /**
   * Trigger get font scale size
   * @param res 
   * @returns
   */
  public getScaleSize(res: Resource | number): string {
    let systemFontSize = 1;
    try {
      systemFontSize = Number(systemParameter.getSync(PERSIST_SYS_FONT_SIZE_SCALE, '1'));
    } catch (error) {
      log.showError('getSync unexcepted error');
    }
    let fontSizeScale: number = systemFontSize || 1;
    let fontSize: number = typeof res === 'number' ? res : px2vp(getContext().resourceManager.getNumber(res.id));
    return fontSizeScale >= MAX_FONT_SCALE ? `${fontSize * MAX_FONT_SCALE}vp` : `${fontSize * fontSizeScale}vp`;
  }

  /**
   * request focus for accessibility
   * @param id 
   * @returns
   */
  public requestAccessibilityFocus(id: string): void {
    let eventInfo: accessibility.EventInfo = ({
      type: 'requestFocusForAccessibility',
      bundleName: 'com.ohos.sceneboard',
      triggerAction: 'common',
      customId: id
    });
    accessibility.sendAccessibilityEvent(eventInfo);
  }

  public isBarHidden(): boolean {
    return SCBOobeManager.isOobeActivated() || SCBSceneSessionManager.getInstance().isScreenLocked();
  }

  public isEnableImmersive(keyboardViewMode: sceneSessionManager.KeyboardViewMode): boolean {
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.LIGHT_IMMERSIVE_MODE ||
      keyboardViewMode === sceneSessionManager.KeyboardViewMode.DARK_IMMERSIVE_MODE) {
      log.showInfo(`enable immersive model, keyboardViewMode is: ${keyboardViewMode}`);
      return true;
    }
    return false;
  }

  public isDarkImmersive(keyboardViewMode: sceneSessionManager.KeyboardViewMode): boolean {
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.DARK_IMMERSIVE_MODE) {
      return true;
    }
    return false;
  }

  public getPanelImmersiveMode(keyboardViewMode: sceneSessionManager.KeyboardViewMode):
    uiEffect.BrightnessBlender {
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.LIGHT_IMMERSIVE_MODE) {
      return PANEL_LIGHT_BLENDER;
    }
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.DARK_IMMERSIVE_MODE) {
      return PANEL_DARK_BLENDER;
    }
    return NONE_BLENDER;
  }


  public getImageImmersiveMode(keyboardViewMode: sceneSessionManager.KeyboardViewMode):
    uiEffect.BrightnessBlender {
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.LIGHT_IMMERSIVE_MODE) {
      return SCBKeyboardPanelManager.getInstance().isFlowLightMode() ?
        IMAGE_FLOWLIGHT_LIGHT_BLENDER : IMAGE_LIGHT_BLENDER;
    }
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.DARK_IMMERSIVE_MODE) {
      return SCBKeyboardPanelManager.getInstance().isFlowLightMode() ?
        IMAGE_FLOWLIGHT_DARK_BLENDER : IMAGE_DARK_BLENDER;
    }
    return NONE_BLENDER;
  }
  
  public getPressedEffectColor(keyboardViewMode: sceneSessionManager.KeyboardViewMode): Resource {
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.LIGHT_IMMERSIVE_MODE) {
      return $r('app.color.keyboard_light_pressed_color');
    }
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.DARK_IMMERSIVE_MODE) {
      return $r('app.color.keyboard_dark_pressed_color');
    }
    return PRESSED_EFFECT_COLOR;
  }

  public getFontAndIconColor(keyboardViewMode: sceneSessionManager.KeyboardViewMode): Resource {
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.LIGHT_IMMERSIVE_MODE) {
      return $r('app.color.keyboard_light_font_and_iocn_color');
    }
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.DARK_IMMERSIVE_MODE) {
      return $r('app.color.keyboard_dark_font_and_iocn_color');
    }
    return FONT_AND_ICON_COLOR;
  }

  public getSelectIconColor(keyboardViewMode: sceneSessionManager.KeyboardViewMode): Resource {
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.LIGHT_IMMERSIVE_MODE) {
      return $r('app.color.keyboard_light_select_iocn_color');
    }
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.DARK_IMMERSIVE_MODE) {
      return $r('app.color.keyboard_dark_select_icon_color');
    }
    if (GlobalContext.getContext().config.colorMode === 1) {
      return $r('app.color.keyboard_light_select_iocn_color');
    }
    return $r('app.color.keyboard_dark_select_icon_color');
  }

  public getNotSelectIconColor(keyboardViewMode: sceneSessionManager.KeyboardViewMode): Resource {
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.LIGHT_IMMERSIVE_MODE) {
      return $r('app.color.keyboard_light_not_select_iocn_color');
    }
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.DARK_IMMERSIVE_MODE) {
      return $r('app.color.keyboard_dark_not_select_icon_color');
    }
    return NOT_SELECT_COLOR;
  }

  public getSplitLineColor(keyboardViewMode: sceneSessionManager.KeyboardViewMode): Resource {
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.LIGHT_IMMERSIVE_MODE) {
      return $r('app.color.keyboard_light_split_Line_color');
    }
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.DARK_IMMERSIVE_MODE) {
      return $r('app.color.keyboard_dark_split_Line_color');
    }
    return SPLIT_LINE_COLOR;
  }

  public getEffectOptions(keyboardViewMode: sceneSessionManager.KeyboardViewMode):
    BackgroundEffectOptions {
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.LIGHT_IMMERSIVE_MODE) {
      return BACK_GROUND_LIGHT_EFFECT;
    }
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.DARK_IMMERSIVE_MODE) {
      return BACK_GROUND_DARK_EFFECT;
    }
    if (GlobalContext.getContext().config.colorMode === 1) {
      return BACK_GROUND_LIGHT_EFFECT;
    }
    return BACK_GROUND_DARK_EFFECT;
  }

  public getImageColor(keyboardViewMode: sceneSessionManager.KeyboardViewMode): number[] {
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.LIGHT_IMMERSIVE_MODE) {
      return PANEL_IMAGE_COLOR;
    }
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.DARK_IMMERSIVE_MODE) {
      return PANEL_IMAGE_COLOR_WHITE;
    }
    if (GlobalContext.getContext().config.colorMode === 1) {
      return PANEL_IMAGE_COLOR;
    }
    return PANEL_IMAGE_COLOR_WHITE;
  }

  private initData(): void {
    this.refreshInputMethodList();
    this.initEnabledSubTypes();
  }
  
  async refreshInputMethodList(): Promise<void> {
    this.inputMethodList = await inputMethod.getSetting().getInputMethods(true);
    let index = 0;
    if (this.defaultInputMethod === null || this.defaultInputMethod === undefined) {
      log.showError('this.defaultInputMethod is null');
      return;
    }
    for (let k = 0; k < this.inputMethodList.length; k++) {
      if (this.inputMethodList[k]?.name === this.defaultInputMethod?.name) {
        index = k;
        break;
      }
    }
    this.inputMethodList.splice(index, 1);
    this.inputMethodList.unshift(this.defaultInputMethod);
  }

  async initEnabledSubTypes(): Promise<void> {
    try {
      let activeSubTypeStr = await settings.getValue(GlobalContext.getContext(),
        settings.input.ACTIVATED_INPUT_METHOD_SUB_MODE, settings.domainName.USER_PROPERTY);
      let activeSubTypes: SubType[] = JSON.parse(activeSubTypeStr);
      if (activeSubTypes?.length <= 0) {
        log.showError('activeSubTypes is invalid value');
        return;
      }
      log.showInfo(`activeSubType: ${JSON.stringify(activeSubTypes)}`);
      let defaultSubTypes = await inputMethod.getSetting().listInputMethodSubtype(this.defaultInputMethod);
      if (defaultSubTypes?.length <= 0) {
        log.showError('defaultSubTypes is invalid value');
        return;
      }
      this.initSubTypes(activeSubTypes, defaultSubTypes);
    } catch (err) {
      let error = err as BusinessError;
      log.showError(`subTypes is empty, message: ${error.message}, code: ${error.code}`);
    }
  }

  initSubTypes(activeSubTypes: SubType[], defaultSubTypes: InputMethodSubtype[]): void {
    this.settingsSubType = [];
    this.activeSubtypes = [];
    for (let k = 0; k < activeSubTypes?.length; k++) {
      for (let j = 0; j < defaultSubTypes?.length; j++) {
        if (activeSubTypes[k].id === defaultSubTypes[j].id) {
          this.activeSubtypes.push(defaultSubTypes[j]);
          this.settingsSubType.push(activeSubTypes[k]);
        }
        if (activeSubTypes[k].isCurrent) {
          this.currentSubtypeIndex = this.activeSubtypes.length - 1;
        }
      }
    }
    log.showInfo(`this.activeSubtypes: ${JSON.stringify(this.activeSubtypes)}`)
  }
  
  async switchNextInputMethod(): Promise<void> {
    let currentInputMethod = inputMethod.getCurrentInputMethod();
    let subTypeNum = this.activeSubtypes.length;
    let inputMethodNum = this.inputMethodList.length;
    if (subTypeNum + inputMethodNum === 0) {
      return;
    }
    let nextIndex = (this.currentSubtypeIndex + 1) % (inputMethodNum + subTypeNum);
    // 当从子类型最后一个到下一个输入法时，跳过默认输入法
    if (nextIndex > 0 && nextIndex === subTypeNum && currentInputMethod.name === this.inputMethodList[0].name) {
      nextIndex = (nextIndex + 1) % (inputMethodNum + subTypeNum);
    }
    log.showInfo('switchNextInputMethod, this.currentSubtypeIndex:' + this.currentSubtypeIndex + ', nextIndex:' +
      nextIndex);
    this.currentSubtypeIndex = nextIndex;
    try {
      if (nextIndex < this.activeSubtypes.length) {
        AppStorage.setOrCreate('smartSelectedIndex', -1);
        await inputMethod.switchInputMethod(this.defaultInputMethod?.name,
          this.activeSubtypes[this.currentSubtypeIndex]?.id);
      } else if (nextIndex - subTypeNum < inputMethodNum) {
        let getPanelSession = SCBKeyboardManager.getInstance().getPanelSession();
        getPanelSession?.setHotSwitch(true);
        getPanelSession?.resetPanelBar();
        await inputMethod.switchInputMethod(this.inputMethodList[nextIndex - subTypeNum]?.name);
      }
    } catch (error) {
      let err = error as BusinessError;
      log.showError(`switchNextInputMethod failed, message: ${err.message}, code: ${err.code}`)
    }
  }
}

const inputMethodUtil = new SCBInputMethodUtil();

export default inputMethodUtil;