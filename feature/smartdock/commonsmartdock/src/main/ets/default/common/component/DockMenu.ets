/**
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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, ResourceManager } from '@ohos/frameworkwrapper';
import { CommonConstants, MenuInfo, StyleConstants } from '@ohos/launchercommon';
import measure from '@ohos.measure';

const TAG = 'DockMenu';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export struct DockMenu {
  appParams?: Map<string, Object>;
  minTextWidth?: number;
  closeMenu: Function = () => {};
  private isBothTypeMenuExist: boolean = true;
  @Prop @Watch('onMenuInfoListChange') menuInfoList: MenuInfo[] = [];
  @State fixedMenuList: MenuInfo[] = [];
  @State dynamicMenuList: MenuInfo[] = [];
  @Provide('dockMenuTextWidth') dockMenuTextWidth: number = StyleConstants.MENU_FONTSIZE;

  private onMenuInfoListChange(): void {
    for (let menuInfo of this.menuInfoList) {
      if (menuInfo.menuType === CommonConstants.MENU_TYPE_FIXED) {
        this.fixedMenuList.push(menuInfo);
      } else {
        this.dynamicMenuList.push(menuInfo);
      }
    }
    this.isBothTypeMenuExist = this.fixedMenuList.length > 0 && this.dynamicMenuList.length > 0;
    AppStorage.setOrCreate<boolean>('isLongPress', true);
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear start');
    this.fixedMenuList = [];
    this.dynamicMenuList = [];
    this.onMenuInfoListChange();
    if (CheckEmptyUtils.isEmpty(this.minTextWidth)) {
      this.dockMenuTextWidth = StyleConstants.MENU_FONTSIZE;
    } else {
      this.dockMenuTextWidth = StyleConstants.MENU_TEXT_MIN_WIDTH;
    }
    AppStorage.setOrCreate<boolean>('isLongPress', true);
    AppStorage.setOrCreate<boolean>('contextMenuState', true);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear start');
    this.fixedMenuList = [];
    this.dynamicMenuList = [];
    AppStorage.setOrCreate<boolean>('contextMenuState', false);
  }

  build() {
    Column() {
      Column() {
        ForEach(this.dynamicMenuList, (item: MenuInfo, index?: number) => {
          DockMenuItem({
            menuInfo: item,
            closeMenu: this.closeMenu,
            appParams: this.appParams,
          })
            .id(`${TAG}_DockMenuItem_dynamicMenu${index}`)
        }, (item: MenuInfo) => JSON.stringify(item))
      }
      .visibility(this.dynamicMenuList.length > 0 ? Visibility.Visible : Visibility.None)

      Divider()
        .vertical(false)
        .color($r('sys.color.ohos_id_color_list_separator'))
        .strokeWidth('1px')
        .margin({
          left: StyleConstants.DEFAULT_12,
          right: StyleConstants.DEFAULT_12,
          bottom: StyleConstants.MENU_MARGIN
        })
        .visibility(this.isBothTypeMenuExist ? Visibility.Visible : Visibility.None)

      Column() {
        ForEach(this.fixedMenuList, (item: MenuInfo, index?: number) => {
          DockMenuItem({
            menuInfo: item,
            closeMenu: this.closeMenu,
            appParams: this.appParams,
          })
            .id(`${TAG}_DockMenuItem_fixedMenu${index}`)
        }, (item: MenuInfo) => JSON.stringify(item))
      }
      .visibility(this.fixedMenuList.length > 0 ? Visibility.Visible : Visibility.None)
    }
    .padding({
      left: StyleConstants.DEFAULT_4,
      right: StyleConstants.DEFAULT_4,
      top: StyleConstants.MENU_MARGIN
    })
    .width(this.dockMenuTextWidth + StyleConstants.DEFAULT_52)
  }
}

@Component
struct DockMenuItem {
  appParams?: Map<string, Object>;
  menuInfo: MenuInfo = new MenuInfo();
  imageFillColor: ResourceColor = $r('sys.color.ohos_id_color_primary');
  closeMenu: Function = () => {};
  private mResourceManager: ResourceManager = ResourceManager.getInstance();
  private isHYM = DeviceHelper.isHYM();
  private edgeAntialias: number = 0;
  @State shortcutIcon: string = StyleConstants.DEFAULT_ICON;
  @State shortcutName: string = '';
  @State hoverState: boolean = false;
  @State pressState: boolean = false;
  @Consume dockMenuTextWidth: number;

  aboutToAppear(): void {
    this.updateIcon();
    this.updateName();
    if (this.isHYM) {
      this.edgeAntialias = 0.5;
    }
  }

  private shortcutIconLoadCallback(image: string): void {
    this.shortcutIcon = image;
  }

  private shortcutNameLoadCallback(name: string): void {
    this.shortcutName = name;
    this.setTextWidth();
  }

  private setTextWidth(): void {
    let needTextWidth: number = Math.round(px2vp(measure.measureText({
      textContent: this.shortcutName,
      fontSize: StyleConstants.MENU_FONTSIZE,
      fontWeight: FontWeight.Regular,
      overflow: TextOverflow.Ellipsis,
      maxLines: 1
    }))) + StyleConstants.DEFAULT_16;
    this.dockMenuTextWidth = needTextWidth > this.dockMenuTextWidth ? needTextWidth : this.dockMenuTextWidth;
  }

  private updateIcon(): void {
    if (this.menuInfo.shortcutIconId != -1 && this.menuInfo.menuImgSrc != '' && this.menuInfo.menuImgSrc != null) {
      this.mResourceManager.getAppIconWithCache(this.menuInfo.shortcutIconId, this.menuInfo.bundleName as string,
        this.menuInfo.moduleName as string, (image: string): void => this.shortcutIconLoadCallback(image),
          StyleConstants.DEFAULT_ICON, 0);
    } else {
      this.shortcutIconLoadCallback(this.menuInfo.menuImgSrc);
    }
  }

  private updateName(): void {
    if (this.menuInfo.shortcutLabelId != -1 && this.menuInfo.menuText != '' && this.menuInfo.menuText != null) {
      this.mResourceManager.getAppNameWithCache(this.menuInfo.shortcutLabelId, this.menuInfo.bundleName,
        this.menuInfo.moduleName, this.shortcutName, (name: string): void => this.shortcutNameLoadCallback(name));
    } else {
      this.shortcutNameLoadCallback(this.menuInfo.menuText);
    }
  }

  private getItemBackgroundColor(): Resource | string {
    if (this.hoverState) {
      return $r('sys.color.ohos_id_color_hover');
    }
    if (this.pressState) {
      return $r('sys.color.ohos_id_color_click_effect');
    }
    return StyleConstants.DEFAULT_TRANSPARENT_COLOR;
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center
    }) {
      if (this.shortcutIcon != null && this.shortcutIcon != '') {
        Image(this.shortcutIcon).draggable(false)
          .id(`${TAG}_Image_shortCut`)
          .objectFit(ImageFit.Contain)
          .fillColor($r('sys.color.ohos_id_color_text_primary'))
          .height(StyleConstants.MENU_IMAGE_HEIGHT_PC)
          .width(StyleConstants.MENU_IMAGE_WIDTH_PC)
          .margin({
            left: StyleConstants.DEFAULT_12
          })
          .flexShrink(0)
          .fillColor(this.imageFillColor)
          .edgeAntialiasing(this.edgeAntialias)
      } else {
        Image('').draggable(false)
          .id(`${TAG}_Image_nullShortCut`)
          .objectFit(ImageFit.Contain)
          .fillColor($r('sys.color.ohos_id_color_primary'))
          .height(StyleConstants.MENU_IMAGE_HEIGHT_PC)
          .width(StyleConstants.MENU_IMAGE_WIDTH_PC)
          .backgroundColor('#33ffffFF')
          .margin({
            left: StyleConstants.DEFAULT_12
          })
          .flexShrink(0)
          .fillColor(this.imageFillColor)
      }
      Text(this.shortcutName).draggable(false)
        .id(`${TAG}_Text_shortCutName`)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize(StyleConstants.MENU_FONTSIZE)
        .fontWeight(FontWeight.Regular)
        .height(StyleConstants.DEFAULT_44)
        .maxLines(1)
        .width(this.dockMenuTextWidth)
        .margin({
          left: StyleConstants.DEFAULT_8
        })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .borderRadius(StyleConstants.DEFAULT_12)
    .height(StyleConstants.DEFAULT_44)
    .width(this.dockMenuTextWidth + StyleConstants.DEFAULT_44)
    .margin({
      bottom: StyleConstants.DEFAULT_4
    })
    .onClick(() => {
      this.menuInfo?.onMenuClick?.(this.appParams);
      this.closeMenu();
      ContextMenu.close();
      AppStorage.setOrCreate('isPopupShow', false);
      this.hoverState = false;
      this.pressState = false;
    })
    .backgroundColor(this.getItemBackgroundColor())
    .onTouch((event?: TouchEvent) => {
      if (event?.type === TouchType.Down) {
        this.pressState = true;
      }
      if (event?.type === TouchType.Up) {
        this.pressState = false;
      }
    })
    .onMouse((event?: MouseEvent) => {
      if (event?.button === MouseButton.Left && event?.action === MouseAction.Press) {
        this.hoverState = false;
        this.pressState = true;
      } else if (event?.button === MouseButton.Left && event?.action === MouseAction.Release) {
        this.pressState = false;
      }
    })
  }
}