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
import { ResUtils, windowMgr } from '@ohos/windowscene';
import { PluginSlot } from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper';
import ViewModel from '../viewmodel/InputMethodPanelViewModel';
import Constants, {
  SwitchType,
  InputMethodInfo,
  InputMethodSubtypeInfo,
  InputMethodItemType
} from '../common/Constants';
import StyleConfiguration, { InputMethodItemStyle } from '../common/StyleConfiguration';
import { NormalPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import StyleConstants from '../../../common/constants/StyleConstants';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { image } from '@kit.ImageKit';

const TAG = 'InputMethodPanelItem';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const COMPONENT_ID_ICON = TAG + '_Image_icon';
const COMPONENT_ID_SELECT = TAG + '_Image_select';
const COMPONENT_ID_TITLE = TAG + '_Text_title';
const COMPONENT_INPUTMETHOD_ITEM = 'COMPONENT_INPUTMETHOD_ITEM'
const WINDOW_NAME = PluginSlot.SLOT_STATUS_INPUT_PANEL;
const SEMIBOLD = 600;

@Component
export default struct InputMethodPanelItem {
  isLanguageItem: boolean = false;
  private inputMethodItem?: InputMethodItemType;
  // 是否为当前项
  @StorageLink('currentInputMethod') mCurrentInputMethodItem: InputMethodInfo = {} as InputMethodInfo;
  @StorageLink('currentInputMethodSubtype') @Watch('updateSubtypeIcon') mCurrentInputMethodSubtype: InputMethodSubtypeInfo = {
  } as InputMethodSubtypeInfo;
  @State style: InputMethodItemStyle = StyleConfiguration.getInputMethodItemStyle();
  @State mIcon: string | image.PixelMap = '';
  @State inputMethodUseSymbolIcon: boolean = false;
  @State mTitle: string | Resource = '';
  @State mKey: string = '';
  @State isSelected: boolean = false;
  @State isHovered: boolean = false;
  @State isFirstItem: boolean = false;
  @Consume persistentId: number;
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State windowName: string = WINDOW_NAME;
  @State showMoreArrow: boolean = false;
  @Link isArrowUp: boolean;
  @State isInList: boolean = false;
  arrowTargetChange? = () => {};

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

  loadInputMethodItem(inputMethodItem?: InputMethodItemType) {
    if (this.inputMethodItem != undefined) {
      log.showInfo(`updateMethodList, inputMethodItem:${JSON.stringify(this.inputMethodItem)}`);
      log.showInfo(`updateMethodList, mCurrentInputMethodSubtype:${JSON.stringify(this.mCurrentInputMethodSubtype)}`);
      ViewModel.updateIcon(this.inputMethodItem, (image: image.PixelMap) => this.iconLoadCallback(image));
      ViewModel.updateTitle(this.inputMethodItem, (title: string) => this.titleLoadCallback(title));
    }
  }

  updateSubtypeIcon() {
    if (this.inputMethodItem != undefined && this.inputMethodItem?.vType != 'InputMethodSubtypeInfo') {
      return;
    }

    let thisSubtypeInfo = this.inputMethodItem as InputMethodSubtypeInfo;
    log.showInfo(`[updateSubtypeIcon] current language:${this.mCurrentInputMethodSubtype?.subtype?.language} mode: ${this.mCurrentInputMethodSubtype?.subtype?.mode}`);
    log.showInfo(`[updateSubtypeIcon] this language:${thisSubtypeInfo?.subtype?.language} mode: ${thisSubtypeInfo?.subtype?.mode}`);

    if (ViewModel.isInputMethodSubtypeInfoEqual(this.mCurrentInputMethodSubtype, thisSubtypeInfo)) {
      // 如果输入法相同但是大小写不同，则把当前输入法更新为对应大小写
      if (this.mCurrentInputMethodSubtype?.subtype?.mode !== thisSubtypeInfo?.subtype?.mode) {
        this.inputMethodItem = this.mCurrentInputMethodSubtype;
        this.loadInputMethodItem(this.inputMethodItem)
      }
    }

    // 如果当前选中的输入法语言一致，且当前输入法item是带有下拉箭头的，则把item的输入法替换为当前输入法
    if (this.mCurrentInputMethodSubtype?.subtype?.locale === thisSubtypeInfo.subtype?.locale &&
        this.showMoreArrow) {
      this.inputMethodItem = this.mCurrentInputMethodSubtype;
      this.loadInputMethodItem(this.inputMethodItem)
    }

    // 英文时，默认显示小写
    if (this.mCurrentInputMethodSubtype?.subtype?.language !== 'english' &&
      thisSubtypeInfo?.subtype?.language === 'english') {
      ViewModel.getDefaultLanguageMode('english',
        (inputMethodInfo: InputMethodItemType): void => this.updateInputMethodItem(inputMethodInfo));
    }
  }

  iconLoadCallback(image: image.PixelMap) {
    log.showDebug(`image:${image}, inputMethodItem:${this.inputMethodItem}`);
    this.mIcon = image;
  }

  titleLoadCallback(title: string) {
    log.showInfo(`title:${title}, inputMethodItem:${this.inputMethodItem}`);
    this.mKey = title;
    this.mTitle = title;
  }

  buildLog(inputMethodItem?: InputMethodItemType): boolean {
    log.showInfo(`inputMethod item:${JSON.stringify(inputMethodItem)}`);
    return true;
  }

  getCheckedColor(): ResourceStr | undefined {
    return this.isChecked() ? this.panelInfo?.selectedListTextColor :
      this.panelInfo?.brightnessBaseColor;
  }

  getCheckedFontWeight(): string | FontWeight {
    return this.isChecked() ? SEMIBOLD : FontWeight.Medium;
  }

  getLeftIconColor(): ResourceStr | undefined {
    return this.isLanguageItem ? this.panelInfo?.listLeftIconColor : undefined;
  }

  private updateInputMethodItem(inputMethodInfo: InputMethodItemType) {
    this.inputMethodItem = inputMethodInfo;
    this.loadInputMethodItem(this.inputMethodItem);
  }

  private getIconSize() {
    if (this.inputMethodItem != undefined && this.inputMethodItem.vType == 'InputMethodInfo') {
      return this.style.inputMethodItemSmallIconSize;
    }
    return this.style.inputMethodItemIconSize;
  }

  private getIconMargin() {
    let margin: LocalizedPadding = {
      start: this.style.inputMethodItemIconMarginLeft,
      end: this.style.inputMethodItemIconMarginRight
    };
    if (this.inputMethodItem != undefined && this.inputMethodItem.vType == 'InputMethodInfo') {
      margin.start = this.style.inputMethodItemSmallIconMarginLeft;
      margin.end = this.style.inputMethodItemSmallIconMarginRight;
    }
    return margin;
  }

  private isChecked(): boolean {
    if (this.inputMethodItem == undefined) {
      return false;
    }

    log.showDebug(`[isChecked] ${this.mCurrentInputMethodItem == this.inputMethodItem}`);
    log.showDebug(`[isChecked] inputMethodItem:${JSON.stringify(this.inputMethodItem)}`);
    log.showDebug(`[isChecked] current inputMethod:${JSON.stringify(this.mCurrentInputMethodItem)}`);
    log.showDebug(`[isChecked] subtype:${JSON.stringify(this.mCurrentInputMethodSubtype)}`);
    if (this.inputMethodItem.vType === 'InputMethodInfo') {
      return ViewModel.isInputMethodPropertyInfoEqual(this.mCurrentInputMethodItem, this.inputMethodItem);
    }
    return ViewModel.isInputMethodSubtypeInfoEqual(this.mCurrentInputMethodSubtype, this.inputMethodItem);
  }

  private getSelectImage() {
    return $r('app.media.ic_selected');
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

  private onTouchEvent(event?: TouchEvent) {
    log.showInfo(`[onTouchEvent] event: ${JSON.stringify(event)}`);
    if (event?.type == TouchType.Down) {
      this.isSelected = true;
    } else if (event?.type == TouchType.Up) {
      this.isSelected = false;
    }
  }

  private onClickEvent(event?: ClickEvent): void {
    log.showInfo(`[onClickEvent] event: ${JSON.stringify(event)}`);
    if (this.isNeedToSwitch()) {
      ViewModel.switchInputMethod(this.inputMethodItem);
      if (this.inputMethodItem != null) {
        if (this.inputMethodItem?.vType == 'InputMethodInfo') {
          ViewModel.reportSwitchEvent(SwitchType.SWITCH_INPUT_METHOD);
        }
        if (this.inputMethodItem?.vType == 'InputMethodSubtypeInfo') {
          ViewModel.reportSwitchEvent(SwitchType.SWITCH_LANGUAGE);
        }
      }
    }
    this.hideWindow();
  }

  private isNeedToSwitch() {
    if (this.inputMethodItem != undefined &&
      !ViewModel.isInputMethodItemTypeEqual(this.inputMethodItem, this.mCurrentInputMethodItem) &&
      !ViewModel.isInputMethodItemTypeEqual(this.inputMethodItem, this.mCurrentInputMethodSubtype)) {
      return true;
    }
    return false;
  }

  private reset() {
    this.isSelected = false;
    this.isHovered = false;
  }

  private getKey(): string {
    return COMPONENT_INPUTMETHOD_ITEM + '_' + this.inputMethodItem?.vType + '_' + this.mKey;
  }

  private hideWindow(): void {
    if (!windowMgr.isShowing(this.windowName)) {
      return;
    }
    log.showInfo(`hide anim start`);
    windowMgr.hideWindowWithAnim(this.windowName);
  }

  private getColorFilter(): ColorFilter | undefined {
    if (!this.isLanguageItem) {
      return undefined;
    }
    return this.panelInfo?.isDark ? Constants.DARK_COLOR_FILTER : Constants.LIGHT_COLOR_FILTER;
  }

  onStateChange() {
    log.showInfo(`[onStateChange]`);
    this.reset();
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.loadInputMethodItem(this.inputMethodItem);
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId) as NormalPanelInfo;
    ViewModel.registerStateChangeListener(this);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    ViewModel.unregisterStateChangeListener(this);
  }

  build() {
    Row() {
      if (this.buildLog(this.inputMethodItem)) {
      }
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        if (this.inputMethodUseSymbolIcon) {
          SymbolGlyph($r('sys.symbol.AI_keyboard'))
            .draggable(false)
            .id(COMPONENT_ID_ICON)
            .fontColor([this.colorModeViewData.wifiOffTextColor]) // 适配提亮压暗
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .fontWeight(FontWeight.Medium)
            .fontSize('24vp')
            .margin(this.getIconMargin())
        } else {
          Image(this.mIcon)
            .draggable(false)
            .id(COMPONENT_ID_ICON)
            .objectFit(ImageFit.Contain)
            .colorFilter(this.getColorFilter())
            .height(this.getIconSize())
            .width(this.getIconSize())
            .margin(this.getIconMargin())
            .borderRadius(6)
            .autoResize(false)
            .interpolation(ImageInterpolation.Medium)
            .fillColor(this.isLanguageItem ? this.colorModeViewData.commonIconOffColor : undefined)
            .foregroundBrightness(this.isLanguageItem ? this.colorModeViewData.foregroundPrimaryOption : undefined)
        }

        Text(this.mTitle)
          .draggable(false)
          .id(COMPONENT_ID_TITLE)
          .fontSize(this.panelInfo?.listTextSize)
          .fontColor(this.getCheckedColor())
          .foregroundBrightness(this.isChecked() ? undefined : this.colorModeViewData.foregroundPrimaryOption)
          .fontWeight(this.getCheckedFontWeight())
          .fontFamily('HarmonyHeiTi')
          .width(this.isInList ? this.style.inputMethodZhItemTextWidth : this.style.inputMethodItemTextWidth)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .direction(RTLUtil.isRTL() ? Direction.Rtl : Direction.Ltr)
          .wordBreak(WordBreak.BREAK_ALL)

        if (this.showMoreArrow) {
          Image(this.isArrowUp ? $r('sys.media.ohos_ic_public_arrow_up')
            : $r('sys.media.ohos_ic_public_arrow_down'))
            .draggable(false)
            .width(this.style.inputMethodSubTypeArrowSize)
            .height(this.style.inputMethodSubTypeArrowSize)
            .fillColor($r('sys.color.icon_tertiary'))
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .onClick(() => {
              if (this.arrowTargetChange) {
                this.arrowTargetChange();
              }
            })
        } else if (this.isChecked()) {
          Image(this.getSelectImage())
            .draggable(false)
            .id(COMPONENT_ID_SELECT)
            .fillColor(this.panelInfo?.selectedListRightIconColor)
            .height(this.style.inputMethodSelectedIconSize)
            .width(this.style.inputMethodSelectedIconSize)
            .autoResize(false)
            .interpolation(ImageInterpolation.Medium)
            .margin({
              end: this.style.inputMethodSelectedIconMarginRight
            })
            .edgeAntialiasing(0.4)
        }
      }
      .focusable(true)
      .key(this.isFirstItem ? Constants.REQUEST_FOCUS_MENU : '')
      .height(this.style.inputMethodItemHeight)
      .borderRadius(this.panelInfo?.hoverRadius)
    }
    .backgroundColor(this.getBackgroundColor())
    .onTouch((event) => this.onTouchEvent(event))
    .onClick((event) => this.onClickEvent(event))
    .onHover((isHover) => {
      this.isHovered = isHover || false;
    })
    .stateStyles({
      normal: this.normalStyles,
      focused: this.focusedStyles
    })
    .borderRadius(this.panelInfo?.hoverRadius)
    .padding({
      start: this.isInList ? this.style.inputMethodItemZhListPaddingLeft : undefined
    })
    .margin({
      start: this.style.inputMethodItemMarginLeft,
      end: this.style.inputMethodItemMarginRight,
      top: this.isFirstItem ? this.style.inputMethodFirstItemMarginTop :
      this.style.inputMethodItemMarginTop,
    })
    .height(this.style.inputMethodItemHeight)
    .key(this.getKey())
    .id(this.getKey())
  }
}