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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext, PluginSlot } from '@ohos/frameworkwrapper';
import {
  ResUtils,
  windowMgr,
  StartAbilityUtil
} from '@ohos/windowscene';
import { ExtAppConstants } from '@ohos/commonconstants';
import ViewModel from '../viewmodel/InputMethodPanelViewModel';
import InputMethodPanelItem from './InputMethodPanelItem';
import inputMethod from '@ohos.inputMethod';
import settings from '@ohos.settings';
import { InputMethodInfo, InputMethodItemType,
  InputMethodSubtypeGroup,
  InputMethodSubtypeInfo } from '../common/Constants';
import StyleConfiguration, { InputMethodPanelComponentStyle } from '../common/StyleConfiguration';
import { NormalPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { LengthMetrics } from '@kit.ArkUI';
import StyleConstants from '../../../common/constants/StyleConstants';
import InputMethodPanelGroup from './InputMethodPanelGroup';
import InputMethodUtils from '@ohos/inputmethodcomponent/src/main/ets/default/common/InputMethodUtils';

const TAG = 'InputMethodPanelComponent';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const COMPONENT_ID_TITLE = TAG + '_Text_title';
const WINDOW_NAME = PluginSlot.SLOT_STATUS_INPUT_METHOD;
const HIDE_INPUT_METHOD_STATUS_BAR = 'settings.input.HIDE_STATUS_BAR';


@Component
export default struct InputMethodPanelComponent {
  @Consume persistentId: number;
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  @StorageLink('inputMethodList') mInputMethodList: Array<InputMethodInfo> = [];
  @StorageLink('languageList') @Watch('parseLanguageList') mLanguageList: Array<InputMethodSubtypeInfo> = [];
  @State mLanguageGroupList: Array<InputMethodSubtypeGroup> = [];
  @State style: InputMethodPanelComponentStyle = StyleConfiguration.getInputMethodPanelComponentStyle();
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State inputMethodStatusBarIsHide: boolean = false;
  @Consume pluginSlot: PluginSlot;
  @State isLanguage: boolean = this.pluginSlot === PluginSlot.SLOT_STATUS_INPUT_PANEL;
  @State isSelected: boolean = false;
  @State isHovered: boolean = false;
  @State isListShow: boolean = true;
  updateInputMethodSubTypeNumber? = (itemNum: number) => {};

  @Styles
  normalStyles() {
    .border({
      width: '2vp',
      color: '#00000000'
    })
  }

  @Styles
  focusedStyles() {
    .border({
      width: '2vp',
      color: this.panelInfo?.isDark ?
      StyleConstants.DEFAULT_DARK_FOCUSED_COLOR :
      StyleConstants.DEFAULT_FOCUSED_COLOR
    })
  }

  @Builder
  MyDivider(marginLeft: LengthMetrics = this.style.inputMethodPanelMarginLeft) {
    Divider()
      .strokeWidth('1px')
      .color(this.panelInfo?.separatorColor)
      .margin({
        start: marginLeft,
        end: this.style.inputMethodPanelMarginRight,
        top: this.style.inputMethodPanelDividerMarginTopBottom,
        bottom: this.style.inputMethodPanelDividerMarginTopBottom,
      })
  }

  @Builder
  InputListComponent() {
    Column() {
      ForEach(Array.from(this.mInputMethodList), (item: InputMethodItemType, index: number = 0) => {
        InputMethodPanelItem({
          inputMethodItem: item,
          isFirstItem: index === 0,
          windowName: WINDOW_NAME,
          isArrowUp: this.isListShow,
        })
      });
    }
  }

  @Builder
  LanguageComponent() {
    Scroll() {
      Column() {
        ForEach(this.mLanguageGroupList, (group: InputMethodSubtypeGroup, index: number) => {
          InputMethodPanelGroup({
            inputMethodSubtypeGroup: group,
            isListShow: this.isListShow,
            showListChange: (): void => this.showListChange(),
            isFirstItem: index === 0,
          })
        });
      }
      .id(TAG + 'LanguageComponent')
    }
  }

  @Builder
  inputStateSetting() {
    Row() {
      Text('')
        .fontSize(14)
        .fontColor($r('sys.color.font_secondary'))
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .fontWeight(FontWeight.Medium)
        .width(312)
        .margin({ start: LengthMetrics.vp(24), end: LengthMetrics.vp(24) })
    }
    .height(32)
    .width('100%')
    .alignItems(VerticalAlign.Center)
    Row() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Row() {
          SymbolGlyph(this.inputMethodStatusBarIsHide ? $r('sys.symbol.eye_slash') : $r('sys.symbol.eye'))
            .draggable(false)
            .fontColor([this.colorModeViewData.wifiOffTextColor]) // 适配提亮压暗
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .fontWeight(FontWeight.Medium)
            .fontSize('24vp')
          Text($r('app.string.hide_input_method_status_bar'))
            .fontSize(16)
            .fontColor(this.colorModeViewData.wifiOffTextColor) // 适配提亮压暗
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .fontWeight(FontWeight.Medium)
            .margin({ start: LengthMetrics.vp(12) })
            .width(220)
        }
        .alignItems(VerticalAlign.Center)

        Toggle({ type: ToggleType.Switch, isOn: this.inputMethodStatusBarIsHide })
          .selectedColor($r('sys.color.ohos_id_color_emphasize'))
          .switchPointColor($r('sys.color.ohos_id_color_foreground_contrary'))
          .width($r('app.float.toggle_comp_width'))
          .height($r('app.float.toggle_comp_height'))
          .onChange((isOn) => {
            this.inputMethodStatusBarIsHide = isOn;
            try {
              settings.setValueSync(GlobalContext.getContext(), HIDE_INPUT_METHOD_STATUS_BAR, isOn.toString());
              log.showInfo('Hide input method status bar change success');
            } catch (e) {
              log.showError('Hide input method status bar change failed');
            }
          })
          .hoverEffect(HoverEffect.Auto)
      }
    }
    .constraintSize({
      minHeight: 40
    })
    .id('hide_input_method_status_bar_text')
    .width('100%')
    .padding({ start: LengthMetrics.vp(24), end: LengthMetrics.vp(22) })
    .alignItems(VerticalAlign.Center)
    this.MyDivider();
  }

  @Builder
  inputSetting() {
    Row() {
      Text(this.getInputSettingString())
        .fontSize($r('sys.float.Body_L'))
        .width(312)
        .constraintSize({ minHeight: 24 })
        .margin({ start: LengthMetrics.vp(20), end: LengthMetrics.vp(20) })
        .fontColor(this.colorModeViewData.wifiOffTextColor) // 适配提亮压暗
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .fontWeight(FontWeight.Medium)
    }
    .backgroundColor(this.getBackgroundColor())
    .borderRadius(this.panelInfo?.hoverRadius)
    .height(40)
    .alignItems(VerticalAlign.Center)
    .margin({ start: LengthMetrics.vp(4), end: LengthMetrics.vp(4) })
    .stateStyles({
      normal: this.normalStyles,
      focused: this.focusedStyles
    })
    .onTouch((event) => this.onTouchEvent(event))
    .onHover((isHover) => {
      this.isHovered = isHover || false;
    })
    .onClick((event) => this.onClickEvent(event))
  }

  getInputSettingString(): string {
    return ResUtils.getInnerStringByName('keyboard_setting');
  }

  buildLog(inputMethodSubTypeInfo: InputMethodItemType) {
    log.showInfo(`inputMethodSubTypeInfo: ${JSON.stringify(inputMethodSubTypeInfo)}}`);
    return true;
  }

  aboutToAppear() {
    log.showInfo(`InputMethodPanelComponent, aboutToAppear`);
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId) as NormalPanelInfo;
    this.mInputMethodList = AppStorage.get('inputMethodList') || [];
    this.mLanguageList = AppStorage.get('languageList') || [];
    this.parseLanguageList();
    ViewModel.registerListeners();
    ViewModel.registerStateChangeListener(this);
    ViewModel.registerUpdatePanelWindowListener(this);
  }

  private parseLanguageList() {
    this.mLanguageGroupList = [];
    log.showInfo(`parseLanguageList length = ` + this.mLanguageList.length);
    this.mLanguageList.forEach((item: InputMethodSubtypeInfo) => {
      if (item === undefined || item === null) {
        return;
      }
      log.showInfo(`parseLanguageList item = ` + JSON.stringify(item));
      let languageIsInGroup: boolean = false;
      this.mLanguageGroupList.forEach((group: InputMethodSubtypeGroup) => {
        if (this.itemBelongGroup(item, group)) {
          group.subtypeList.push(item);
          languageIsInGroup = true;
        }
      })
      if (!languageIsInGroup) {
        let itemGroup: InputMethodSubtypeGroup = {
          languageLocale: item.subtype.locale,
          subtypeList: [],
        };
        itemGroup.subtypeList.push(item);
        this.mLanguageGroupList.push(itemGroup);
      }
    })
    this.updateSubTypePanel();
  }

  itemBelongGroup(item: InputMethodSubtypeInfo, group: InputMethodSubtypeGroup): boolean {
    return item.subtype.locale === group.languageLocale;
  }

  showListChange() {
    this.isListShow = !this.isListShow;
    this.updateSubTypePanel();
  }

  updateSubTypePanel() {
    let listLength = this.mLanguageGroupList.length;
    if (this.isListShow) {
      listLength = this.mLanguageList.length;
      this.mLanguageGroupList.forEach((group) => {
        if (group.subtypeList.length > 1) {
          listLength ++;
        }
      })
    }
    if (this.updateInputMethodSubTypeNumber) {
      this.updateInputMethodSubTypeNumber(listLength);
    }
  }

  aboutToDisappear() {
    log.showInfo(`InputMethodPanelComponent, aboutToDisAppear`);
    this.mLanguageGroupList = [];
    ViewModel.unregisterListeners();
    ViewModel.unregisterStateChangeListener(this);
    ViewModel.unregisterUpdatePanelWindowListener(this);
  }

  build() {
    Column() {
      if (!this.isLanguage) {
        // 输入法列表
        this.InputListComponent()
        this.MyDivider()
        // 输入法设置
        this.inputSetting();
      } else {
        // 语言列表
        this.LanguageComponent()
      }
    }
  }

  private onTouchEvent(event?: TouchEvent) {
    log.showInfo(`[onTouchEvent] event: ${JSON.stringify(event)}`);
    if (event?.type == TouchType.Down) {
      this.isSelected = true;
    } else if (event?.type == TouchType.Up) {
      this.isSelected = false;
    }
  }

  private getBackgroundColor() {
    if (this.isSelected) {
      return this.panelInfo?.isDark ?
      StyleConstants.DEFAULT_DARK_PRESS_COLOR : StyleConstants.DEFAULT_PRESS_COLOR;
    }
    if (this.isHovered) {
      return this.panelInfo?.isDark ?
      StyleConstants.DEFAULT_DARK_HOVER_COLOR : StyleConstants.DEFAULT_HOVER_COLOR;
    }
    return $r('app.color.transparent');
  }

  private reset() {
    this.isSelected = false;
    this.isHovered = false;
  }

  onStateChange() {
    log.showInfo('[onStateChange]');
    this.reset();
  }

  async updateInputMethodPanelWindow() {
    try {
      this.inputMethodStatusBarIsHide =
        settings.getValueSync(GlobalContext.getContext(), HIDE_INPUT_METHOD_STATUS_BAR, 'false') === 'true';
    } catch (error) {
      log.showError(`getCurrentInputMethod fail, error: ${error}`);
    }
  }

  private hideWindow(): void {
    if (!windowMgr.isShowing(WINDOW_NAME)) {
      return;
    }
    log.showInfo('hide anim start');
    windowMgr.hideWindowWithAnim(WINDOW_NAME);
  }

  private onClickEvent(event?: ClickEvent): void {
    let moduleName: string = DeviceHelper.is2In1DevicePcType() ? 'phone_settings' : 'pc_settings';
    let uri: string = DeviceHelper.is2In1DevicePcType() ? 'pad_keyboard_settings_entry' : 'pc_keyboard';
    log.showInfo(`[onClickEvent] event: ${JSON.stringify(event)}`);
    this.hideWindow();
    StartAbilityUtil.startAbilityFromOther({
      bundleName: 'com.ohos.settings',
      abilityName: 'com.ohos.settings.MainAbility',
      uri: uri,
      moduleName: moduleName,
    });
  }
}