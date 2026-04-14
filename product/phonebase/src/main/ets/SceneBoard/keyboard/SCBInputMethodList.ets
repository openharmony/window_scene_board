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

import bundleManager from '@ohos.bundle.bundleManager';
import common from '@ohos.app.ability.common';
import inputMethod from '@ohos.inputMethod';
import inputMethodUtil from './SCBInputMethodUtil';
import InputMethodSubtype from '@ohos.InputMethodSubtype';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { dialogStyle } from './SCBKeyboardDialog';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  SCBScreenSessionManager,
  SCBKeyboardManager,
  PatternAction,
  SCBKeyboardPanelManager,
  SCBKeyboardPanelSession
} from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SubType } from './SCBInputMethodUtil';

const ALL_PATTERNS: Resource[] = [
  $r('sys.symbol.keyboard'),
  $r('sys.symbol.keyboard_thumbmode'),
  $r('sys.symbol.keyboard_square'),
  $r('sys.symbol.onehand')
];
const TAG: string = 'SCBIMFKeyboardListDialog';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Extend(Divider)
function divider(keyboardViewMode: sceneSessionManager.KeyboardViewMode) {
  .color(inputMethodUtil.getSplitLineColor(keyboardViewMode))
  .height('1px')
  .margin({ left: dialogStyle.listItemPadding, right: dialogStyle.listItemPadding })
}

@Extend(Text)
function textStyle(weight: Resource) {
  .fontFamily(weight)
}

PersistentStorage.persistProp('patternOption', 0);

@Component
export struct SCBInputMethodList {
  @State inputMethods: Array<inputMethod.InputMethodProperty> = [];
  @State subTypes: Array<InputMethodSubtype> = [];
  @State showHand: boolean = false;
  @State inputMethodConfig: bundleManager.ElementName | undefined = undefined;
  @State defaultInputMethod: inputMethod.InputMethodProperty | undefined = undefined;
  @State currentInputMethod: inputMethod.InputMethodProperty | undefined = undefined;
  @State currentSub: InputMethodSubtype | undefined = undefined;
  @Link listMaxNum: number;
  @Link isShowDialog: boolean;
  @ObjectLink keyboardPanelSession: SCBKeyboardPanelSession;
  @StorageLink('patternOption') patternOption: number = 0;
  @State patternIndex: number = this.patternOption;
  @State lastItemPressed: boolean = false;
  private activeSubtypes: Array<SubType> = [];
  private patterns: Resource[] = [];
  private isLand: boolean = false;
  private scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    this.isLand = SCBKeyboardPanelManager.getInstance().isPhoneLand();
    this.initPatterns();
    this.getDefaultInputMethodSubType();
  }

  getDefaultInputMethodSubType(): void {
    log.showInfo(`getDefaultInputMethodSubType`);
    this.inputMethodConfig = inputMethod.getSystemInputMethodConfigAbility();
    if (this.inputMethodConfig) {
      log.showInfo(`inputMethodConfig:  ${JSON.stringify(this.inputMethodConfig)}`);
    }
    this.inputMethods = inputMethodUtil.inputMethodList;
    this.defaultInputMethod = inputMethodUtil.defaultInputMethod;
    this.currentInputMethod = inputMethod.getCurrentInputMethod();
    log.showInfo(`defaultInput: ${JSON.stringify(this.defaultInputMethod)}`);
    if (this.defaultInputMethod?.name === this.currentInputMethod?.name && !this.isLand) {
      this.showHand = true;
    } else {
      this.showHand = false;
    }
    this.subTypes = inputMethodUtil.activeSubtypes;
    this.activeSubtypes = inputMethodUtil.settingsSubType;
    this.currentSub = inputMethodUtil.activeSubtypes[inputMethodUtil.currentSubtypeIndex];
    setTimeout(() => {
      if (inputMethodUtil.currentSubtypeIndex >= this.activeSubtypes.length) {
        this.scroller.scrollToIndex(inputMethodUtil.currentSubtypeIndex);
      } else {
        this.scroller.scrollToIndex(inputMethodUtil.currentSubtypeIndex + 1);
      }
    }, 100);
    log.showInfo(`this.subTypes = ${JSON.stringify(this.subTypes)}`);
  }

  initPatterns() {
    this.patterns = [];
    if (SCBKeyboardPanelManager.getInstance().isShowThumbAndFloatKeyboard()) {
      this.patterns = ALL_PATTERNS.filter((value: Resource, index: number) => {
        return index !== PatternAction.ONE_HAND;
      })
    } else {
      this.patterns = ALL_PATTERNS.filter((value: Resource, index: number) => {
        return index !== PatternAction.THUMB && index !== PatternAction.FLOATING;
      })
    }
    this.patternIndex = SCBKeyboardManager.getInstance().getPanelSession()?.getPatternOption();
    log.showInfo(`this.patternIndex = ${this.patternIndex}`);
  }

  isDefaultInputMethodCurrentSubType(id: string, isSubtype: boolean) {
    if (isSubtype) {
      return this.defaultInputMethod?.name === this.currentInputMethod?.name && this.currentSub?.id === id;
    }
    return id === this.currentInputMethod?.name;
  }

  @Styles
  listItemStyle() {
    .width('100%')
    .height(dialogStyle.listItemHeight)
    .padding({ left: dialogStyle.listItemPadding, right: dialogStyle.listItemPadding })
    .borderRadius(dialogStyle.listItemRadius)
  }

  @Builder
  settingsBuilder() {
    if (this.inputMethodConfig && this.inputMethodConfig?.bundleName.length > 0) {
      ListItem() {
        Text($r('sys.string.ohos_id_input_method_settings'))
          .textStyle(dialogStyle.listFontWeight)
          .width('100%')
          .fontSize(dialogStyle.listFontSize)
          .fontColor(inputMethodUtil.getFontAndIconColor(this.keyboardPanelSession?.keyboardViewMode))
          .maxLines(1)
      }
      .listItemStyle()
      .stateStyles({
        pressed: { .backgroundColor(inputMethodUtil.getPressedEffectColor(
          this.keyboardPanelSession?.keyboardViewMode)) },
        normal: { .backgroundColor(dialogStyle.listItemColor) }
      })
      .id('inputMethodSettings')
      .onAppear(() => {
        inputMethodUtil.requestAccessibilityFocus('inputMethodSettings');
      })
      .onClick(()=>{
        this.startInputMethodSettings();
      })
    }
  }

  @Builder
  keyboardModeItem(item: Resource, index: number) {
    Row() {
      Text() {
        SymbolSpan(item)
          .fontSize(dialogStyle.listImageSize)
          .draggable(false)
          .fontColor([index === this.getPatternMode() ?
            inputMethodUtil.getSelectIconColor(this.keyboardPanelSession?.keyboardViewMode) :
            inputMethodUtil.getNotSelectIconColor(this.keyboardPanelSession?.keyboardViewMode)])
      }
    }
    .justifyContent(FlexAlign.Center)
    .size({ width: dialogStyle.imageBtnWidth, height: dialogStyle.imageBtnHeight })
    .borderRadius(dialogStyle.listItemRadius)
    .accessibilityGroup(true)
    .accessibilityText(this.getKeyboardModeAccessText(item))
    .stateStyles({
      pressed: {
        .backgroundColor(inputMethodUtil.getPressedEffectColor(this.keyboardPanelSession?.keyboardViewMode))
      },
      normal: {
        .backgroundColor(dialogStyle.listItemColor)
      }
    })
    .onClick(() => {
      this.switchPositionPattern(index);
    })
  }

  @Builder
  keyboardModeBuilder() {
    Row() {
      ForEach(this.patterns, (item: Resource, index: number) => {
        this.keyboardModeItem(item, index)
      }, (item: Resource) => JSON.stringify(item));
    }
    .width('100%')
    .height(dialogStyle.listItemHeight)
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  @Builder
  InputMethodItem(name: string | undefined, isDefaultInputMethodCurrentSubType: boolean) {
    Row() {
      Row() {
        Text(name)
          .fontSize(dialogStyle.listFontSize)
          .textStyle(dialogStyle.listFontWeight)
          .fontColor(inputMethodUtil.getFontAndIconColor(this.keyboardPanelSession?.keyboardViewMode))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .layoutWeight(1)
      if (isDefaultInputMethodCurrentSubType) {
        Text() {
          SymbolSpan($r('sys.symbol.checkmark'))
            .fontSize(dialogStyle.listImageSize)
            .fontColor([inputMethodUtil.getFontAndIconColor(this.keyboardPanelSession?.keyboardViewMode)])
        }
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  subTypeView() {
    ForEach(this.subTypes, (item: InputMethodSubtype, index: number) => {
      ListItem() {
        this.InputMethodItem(this.activeSubtypes[index]?.name, this.isDefaultInputMethodCurrentSubType(item?.id, true));
      }
      .listItemStyle()
      .stateStyles({
        pressed: { .backgroundColor(inputMethodUtil.getPressedEffectColor(
          this.keyboardPanelSession?.keyboardViewMode)) },
        normal: { .backgroundColor(dialogStyle.listItemColor) }
      })
      .onTouch((event: TouchEvent) => {
        if ((index === this.subTypes.length - 1) && event.type === TouchType.Move &&
          this.inputMethods.length === 1) {
          this.lastItemPressed = true;
        } else {
          this.lastItemPressed = false;
        }
      })
      .onClick(()=>{
        this.switchMethodSub(item, index);
      })
    }, (item: inputMethod.InputMethodProperty) => JSON.stringify(item));
  }

  onTouchStyle(event: TouchEvent, index: number) {
    if ((index === this.inputMethods.length - 1) && event.type === TouchType.Move) {
      this.lastItemPressed = true;
    } else {
      this.lastItemPressed = false;
    }
  }

  @Builder
  inputMethodList() {
    ForEach(this.inputMethods, (item: inputMethod.InputMethodProperty, index: number) => {
      if (this.subTypes.length === 0 || (item?.name !== this.defaultInputMethod?.name)) {
        ListItem() {
          this.InputMethodItem(item?.label, this.isDefaultInputMethodCurrentSubType(item?.name, false));
        }
        .listItemStyle()
        .stateStyles({
          pressed: { .backgroundColor(inputMethodUtil.getPressedEffectColor(
            this.keyboardPanelSession?.keyboardViewMode)) },
          normal: { .backgroundColor(dialogStyle.listItemColor) }
        })
        .onTouch((event: TouchEvent) => {
          this.onTouchStyle(event, index);
        })
        .onClick(() => {
          this.switchMethod(item, index);
        })
      }
    }, (item: inputMethod.InputMethodProperty) => JSON.stringify(item));
  }

  build() {
    Stack({alignContent: Alignment.Bottom}) {
      List({ scroller: this.scroller }) {
        this.settingsBuilder();
        this.subTypeView();
        this.inputMethodList();
      }
      .width('100%')
      .constraintSize({
        maxHeight: this.listMaxNum > 0 ? (this.listMaxNum * dialogStyle.listItemHeight) : '100%'
      })
      .borderRadius(dialogStyle.listItemRadius)
      .scrollBar(BarState.Auto)
      .margin({ bottom: this.showHand ? dialogStyle.listItemHeight : 0 } )
      .divider({
        color: inputMethodUtil.getSplitLineColor(this.keyboardPanelSession?.keyboardViewMode),
        strokeWidth: '1px',
        startMargin: dialogStyle.listItemPadding,
        endMargin: dialogStyle.listItemPadding
      })

      if (this.showHand) {
        Column() {
          Divider()
            .divider(this.keyboardPanelSession?.keyboardViewMode)
            .visibility( this.lastItemPressed ? Visibility.Hidden : Visibility.Visible)
          this.keyboardModeBuilder();
        }
      }
    }
    .width(dialogStyle.listWidth)
    .margin({ 
      top: dialogStyle.listPadding + (this.isLand ? 0 : SCBKeyboardPanelManager.getInstance().getBangsHeight())
    })
    .borderRadius(dialogStyle.listRadius)
    .padding(dialogStyle.listPadding)
    .shadow(ShadowStyle.OUTER_DEFAULT_MD)
    .backgroundEffect(inputMethodUtil.getEffectOptions(this.keyboardPanelSession?.keyboardViewMode),
      { disableSystemAdaptation: true })
  }

  startInputMethodSettings(): void {
    if (this.inputMethodConfig) {
      let context = getContext(this) as common.UIAbilityContext;
      this.dismissKeyboardDialog();
      context.startAbility({
        bundleName: this.inputMethodConfig.bundleName,
        moduleName: this.inputMethodConfig.moduleName,
        abilityName: this.inputMethodConfig.abilityName,
        uri: 'pages/setting',
        parameters: {
          'secondUrl': 'keyboardLanguageSetting',
          'ability.params.backToOtherMissionStack': true
        }
      });
    }
  }

  getKeyboardModeAccessText(item: Resource) {
    let res = getContext(this).resourceManager;
    let index = ALL_PATTERNS.indexOf(item);
    switch (index) {
      case PatternAction.NORMAL:
        return res.getStringByNameSync('keyboard_common_access_text');
      case PatternAction.THUMB:
        return res.getStringByNameSync('keyboard_thumb_access_text');
      case PatternAction.FLOATING:
        return res.getStringByNameSync('keyboard_float_access_text');
      case PatternAction.ONE_HAND:
        return res.getStringByNameSync('keyboard_one_hand_access_text');
      default:
        return '';
    }
  }

  getPatternMode() {
    switch (this.patternIndex) {
      case PatternAction.NORMAL:
        return 0;
      case PatternAction.ONE_HAND:
      case PatternAction.THUMB:
        return 1;
      case PatternAction.FLOATING:
        return 2;
      default:
        return -1;
    }
  }

  switchPositionPattern(mode: number) {
    let patternMode: PatternAction = PatternAction.NORMAL;
    switch (mode) {
      case 0:
        patternMode = PatternAction.NORMAL;
        break;
      case 1:
        if (SCBKeyboardPanelManager.getInstance().isShowThumbAndFloatKeyboard()) {
          patternMode = PatternAction.THUMB;
        } else {
          patternMode = PatternAction.ONE_HAND;
        }
        break;
      case 2:
        patternMode = PatternAction.FLOATING;
        break;
      default:
        break;
    }
    SCBKeyboardManager.getInstance().getPanelSession()?.sendPrivateCommand(patternMode);
    this.dismissKeyboardDialog();
  }

  dismissKeyboardDialog(): void {
    this.isShowDialog = false;
    SCBKeyboardPanelManager.getInstance().setPanelDialogVisibility(false);
  }

  switchMethod(inputProperty: inputMethod.InputMethodProperty, index: number) {
    if (this.currentInputMethod?.name !== inputProperty?.name) {
      let getPanelSession = SCBKeyboardManager.getInstance().getPanelSession();
      getPanelSession?.setHotSwitch(true);
      getPanelSession?.resetPanelBar();
      if (getPanelSession?.smartKeys) {
        SCBKeyboardPanelManager.getInstance().resetSmartMode(getPanelSession?.smartKeys);
      }
      inputMethod.switchInputMethod(inputProperty?.name).then(() => {
        this.currentInputMethod = inputProperty;
      })
      inputMethodUtil.currentSubtypeIndex = this.subTypes.length + index;
    }
    this.dismissKeyboardDialog();
  }

  switchMethodSub(inputSub: InputMethodSubtype, index: number) {
    log.showInfo(`switchMethodSub ${JSON.stringify(inputSub)}}`);
    inputMethod.switchInputMethod(this.defaultInputMethod?.name, inputSub?.id).then(() => {
      this.currentInputMethod = this.defaultInputMethod;
      this.dismissKeyboardDialog();
    })
    inputMethodUtil.currentSubtypeIndex = index;
  }
}