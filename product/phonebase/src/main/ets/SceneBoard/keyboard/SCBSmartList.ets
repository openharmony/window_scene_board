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

import common from '@ohos.app.ability.common';
import inputMethod from '@ohos.inputMethod';
import sceneSessionManager from '@ohos.sceneSessionManager';
import inputMethodUtil from './SCBInputMethodUtil';
import { dialogStyle } from './SCBKeyboardDialog';
import { image } from '@kit.ImageKit';
import { ResourceManager, GlobalContext } from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper';
import { SCBKeyboardManager, SmartMenuItem, SCBKeyboardPanelManager, SCBKeyboardPanelSession } from '@ohos/windowscene';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'SCBIMFSMARTLIST';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Component
struct MenuItemView {
  @State icon: string | image.PixelMap = '';
  @State selectedIcon: string | image.PixelMap = '';
  @State menuText: string = '';
  private index: number = 0;
  private menuItem: SmartMenuItem | undefined = undefined;
  @State isSelected: boolean | undefined = false;
  private defaultInputMethod = inputMethod.getDefaultInputMethod().name;
  @ObjectLink keyboardPanelSession: SCBKeyboardPanelSession;

  aboutToAppear() {
    this.updateInfo();
    this.getSmartSelect();
  }

  updateInfo = async () => {
    try {
      if (this.menuItem) {
        if (this.menuItem?.name?.split(':').length > 1) {
          let resId = this.menuItem?.name.split(':')[1];
          this.menuText = await ResourceManager.getInstance().getAppNameSync(parseInt(resId),
            this.defaultInputMethod, 'default', '');
        }
        if (this.menuItem.normalIcon && this.menuItem?.normalIcon.split(':').length > 1) {
          let resId = this.menuItem?.normalIcon.split(':')[1];
          ResourceManager.getInstance().getNormalMediaAppIconWithCache(parseInt(resId), this.defaultInputMethod, 'default',
            (icon: image.PixelMap) => { this.icon = icon; }, '');
        }
        if (this.menuItem.selectedIcon && this.menuItem?.selectedIcon.split(':').length > 1) {
          let resId = this.menuItem?.selectedIcon.split(':')[1];
          ResourceManager.getInstance().getNormalMediaAppIconWithCache(parseInt(resId), this.defaultInputMethod, 'default',
            (icon: image.PixelMap) => { this.selectedIcon = icon; }, '');  
        }
      }
    } catch (error) {
      log.showError(`updateInfo failed, message: ${error.message}`);
    }
  }

  getSmartSelect(): void {
    let smartSelected: Map<string, boolean> = AppStorage.get('smartSelected') as Map<string, boolean>;
    if (smartSelected) {
      if (this.menuItem?.actionType === 'subType' && this.menuItem?.actionParams?.subType) {
        this.isSelected = smartSelected.get(this.menuItem?.actionParams?.subType);
      }
      if (this.menuItem?.actionType === 'privateCommand' && this.menuItem?.actionParams?.parameters?.key) {
        this.isSelected = smartSelected.get(this.menuItem?.actionParams?.parameters?.key);
      }
    }
  }

  @Builder
  menuIcon() {
    if (this.menuItem?.normalIcon) {
      Image(this.isSelected ? this.selectedIcon : this.icon)
        .size({
          width: dialogStyle.listImageSize,
          height: dialogStyle.listImageSize
        })
        .objectFit(ImageFit.Cover)
        .interpolation(ImageInterpolation.Medium)
        .colorFilter(inputMethodUtil.getImageColor(this.keyboardPanelSession?.keyboardViewMode))
    }
  }


  private getMenuTextMargin(): Margin {
    if (RTLUtil.isRTL()) {
      return { right: this.menuItem?.normalIcon ? (dialogStyle.imageMargin) : 0 };
    }
    return { left: this.menuItem?.normalIcon ? (dialogStyle.imageMargin) : 0 };
  }

  build() {
    Row() {
      this.menuIcon();
      Row() {
        Text(this.menuText)
          .fontSize(dialogStyle.listFontSize)
          .fontFamily(dialogStyle.listFontWeight)
          .margin(this.getMenuTextMargin())
          .fontColor(inputMethodUtil.getFontAndIconColor(this.keyboardPanelSession?.keyboardViewMode))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .layoutWeight(1)
      if (this.isSelected) {
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
}

@Component
export struct SCBSmartList {
  @State isNeedSetId: boolean = true;
  @State smartMenu: Array<SmartMenuItem> = [];
  @Link isShowDialog: boolean;
  @ObjectLink keyboardPanelSession: SCBKeyboardPanelSession;
  private gravity: sceneSessionManager.KeyboardGravity = sceneSessionManager.KeyboardGravity.GRAVITY_BOTTOM;
  private isRequestAccessFocus: boolean = true;

  aboutToAppear(): void {
    this.smartMenu = this.keyboardPanelSession?.getSmartMenuList(this.gravity);
  }

  getIsNeedSetId(): boolean {
    if (this.isNeedSetId) {
      this.isNeedSetId = false;
      return true;
    }
    return false;
  }

  isShowMenuItem(item: SmartMenuItem): boolean {
    let currentInputMethod = inputMethod.getCurrentInputMethod();
    if (currentInputMethod?.name !== inputMethodUtil.defaultInputMethod?.name && item.actionType === 'privateCommand') {
      return false;
    }
    return !item.isDefault;
  }

  @Builder
  smartItemView(item: SmartMenuItem, index: number) {
    ListItem() {
      MenuItemView({ menuItem: item, index: index, keyboardPanelSession: this.keyboardPanelSession })
    }
    .width('100%')
    .height(dialogStyle.listItemHeight)
    .borderRadius(dialogStyle.listItemRadius)
    .padding({ left: dialogStyle.listItemPadding, right: dialogStyle.listItemPadding })
    .stateStyles({
      pressed: {
        .backgroundColor(inputMethodUtil.getPressedEffectColor(this.keyboardPanelSession?.keyboardViewMode))
      },
      normal: {
        .backgroundColor(dialogStyle.listItemColor)
      }
    })
    .id(this.getIsNeedSetId() ? 'smartListFirstItem' : '')
    .onAppear(() => {
      if (this.isRequestAccessFocus) {
        inputMethodUtil.requestAccessibilityFocus('smartListFirstItem');
        this.isRequestAccessFocus = false;
      }
    })
    .onClick(() => {
      this.handleSmartAction(item, index);
    })
  }

  build() {
    List() {
      ForEach(this.smartMenu, (item: SmartMenuItem, index: number) => {
        if (this.isShowMenuItem(item)) {
          this.smartItemView(item, index);
        }
      }, (item: SmartMenuItem) => item.name)
    }
    .width(dialogStyle.listWidth)
    .divider({
      color: inputMethodUtil.getSplitLineColor(this.keyboardPanelSession?.keyboardViewMode),
      strokeWidth: '1px',
      startMargin: dialogStyle.listItemPadding,
      endMargin: dialogStyle.listItemPadding
    })
    .scrollBar(BarState.Auto)
    .borderRadius(dialogStyle.listRadius)
    .padding(dialogStyle.listPadding)
    .backgroundEffect(inputMethodUtil.getEffectOptions(this.keyboardPanelSession?.keyboardViewMode),
      { disableSystemAdaptation: true })
    .shadow(ShadowStyle.OUTER_DEFAULT_MD)
  }

  dismissKeyboardDialog(): void {
    this.isShowDialog = false;
    SCBKeyboardPanelManager.getInstance().setPanelDialogVisibility(false);
  }

  async handleSmartAction(item: SmartMenuItem, index: number) {
    let defaultInputMethod = inputMethod.getDefaultInputMethod();
    if (!defaultInputMethod) {
      return;
    }
    if (item && item.actionType === 'privateCommand') {
      let parametersKey: string = item?.actionParams?.parameters?.key as string;
      SCBKeyboardPanelManager.getInstance().sendSmartType(parametersKey, false);
      this.dismissKeyboardDialog();
      return;
    }
    if (item && item.actionType === 'ability') {
      let context = getContext(this) as common.UIAbilityContext;
      let parametersValue: string = item?.actionParams?.parameters?.value as string;
      await context.startAbility({
        bundleName: defaultInputMethod?.name,
        abilityName: item?.actionParams?.abilityName,
        moduleName: item?.actionParams?.module,
        uri: item?.actionParams?.uri,
        parameters: {
          secondUrl : parametersValue,
          'ability.params.backToOtherMissionStack': true
        }
      });
      this.dismissKeyboardDialog();
      return;
    }
    if (item && item.actionType === 'subType') {
      inputMethod.switchInputMethod(defaultInputMethod?.name, item?.actionParams.subType);
    }
    this.dismissKeyboardDialog();
  }
}