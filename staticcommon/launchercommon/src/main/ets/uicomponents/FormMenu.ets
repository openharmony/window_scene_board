/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

import { LengthMetrics } from '@kit.ArkUI';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { DeviceHelper, ResourceManager, IconResourceManager, localEventManager } from '@ohos/frameworkwrapper';
import { desktopUtil } from '@ohos/componenthelper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { MenuInfo } from '../bean/MenuInfo';
import { CommonConstants } from '../constants/CommonConstants';
import { StyleConstants } from '../constants/StyleConstants';
import { EventConstants } from '../constants/EventConstants';
import { image } from '@kit.ImageKit';

const TAG = 'FormMenu';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Component
export default struct FormMenu {
  menuInfoList: MenuInfo[] = [];
  menuMode: number = CommonConstants.MENU_UI_MODE_LIGHT;
  fixedMenuList: Array<MenuInfo> = [];
  dynamicMenuList: Array<MenuInfo> = [];
  isBothTypeMenuExist: boolean = true;
  closeMenu: Function = () => {
  };
  private isPc: boolean = DeviceHelper.isPC();
  menuWidth: number = this.getMenuWidth();

  private getMenuWidth(): number {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      return desktopUtil.getSmallFoldFormMenuWidthColumns();
    }
    return !this.isPc ? StyleConstants.CONTEXT_FORM_MENU_WIDTH : StyleConstants.MENU_WIDTH_COLUMNS_PC;
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear start');
    this.fixedMenuList = new Array<MenuInfo>();
    this.dynamicMenuList = new Array<MenuInfo>();
    for (let menuInfo of this.menuInfoList) {
      if (menuInfo.menuType == CommonConstants.MENU_TYPE_FIXED) {
        this.fixedMenuList.push(menuInfo);
      } else {
        this.dynamicMenuList.push(menuInfo);
      }
    }
    this.isBothTypeMenuExist = this.fixedMenuList.length > 0 && this.dynamicMenuList.length > 0;
    AppStorage.setOrCreate('isLongPress', true);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear start');
    this.fixedMenuList = [];
    this.dynamicMenuList = [];
  }

  private getCardMenuWidth(): number {
    return !this.isPc ? this.menuWidth : (this.menuWidth - 2 * StyleConstants.DEFAULT_4);
  }

  build() {
    Column() {
      Column() {
        ForEach(this.dynamicMenuList, (item: MenuInfo, index: number): void => {
          HorizontalMenuItem({
            menuInfo: item,
            menuMode: this.menuMode,
            closeMenu: this.closeMenu,
            menuWidth: this.getCardMenuWidth()
          }).id(`${TAG}_HorizontalMenuItem_${index}`)
        }, (item: MenuInfo) => JSON.stringify(item))
      }
      .visibility(this.dynamicMenuList.length > 0 ? Visibility.Visible : Visibility.None)

      if (this.isBothTypeMenuExist) {
        Divider()
          .vertical(false)
          .color($r('sys.color.ohos_id_color_list_separator'))
          .strokeWidth(px2vp(1))
          .margin({
            start: LengthMetrics.vp(StyleConstants.DEFAULT_44),
            end: LengthMetrics.vp(StyleConstants.DEFAULT_12),
            top: LengthMetrics.vp(StyleConstants.MENU_MARGIN),
            bottom: LengthMetrics.vp(StyleConstants.MENU_MARGIN),
          })
      }

      Column() {
        ForEach(this.fixedMenuList, (item: MenuInfo, index: number) => {
          HorizontalMenuItem({
            menuInfo: item,
            menuMode: this.menuMode,
            closeMenu: this.closeMenu,
            menuWidth: this.getCardMenuWidth()
          }).id(`${TAG}_HorizontalMenuItem_sec${index}`)

          if (index !== this.fixedMenuList.length - 1) {
            Divider()
              .color($r('sys.color.ohos_id_color_list_separator'))
              .strokeWidth(px2vp(1))
              .margin({
                start: !this.isPc ?
                  LengthMetrics.vp(StyleConstants.DEFAULT_44) : LengthMetrics.vp(StyleConstants.DEFAULT_60),
                end: !this.isPc ? LengthMetrics.vp(StyleConstants.DEFAULT_12) : LengthMetrics.vp(16.5),
              })
          }
        }, (item: MenuInfo) => JSON.stringify(item))
      }
      .visibility(this.fixedMenuList.length > 0 ? Visibility.Visible : Visibility.None)
    }
    .padding({
      top: !this.isPc ? StyleConstants.DEFAULT_0 : StyleConstants.DEFAULT_2,
      bottom: !this.isPc ? StyleConstants.DEFAULT_0 : StyleConstants.DEFAULT_2,
      start: !this.isPc ? LengthMetrics.vp(StyleConstants.DEFAULT_0) : LengthMetrics.vp(StyleConstants.DEFAULT_4),
      end: !this.isPc ? LengthMetrics.vp(StyleConstants.DEFAULT_0) : LengthMetrics.vp(StyleConstants.DEFAULT_4),
    })
    .width(this.menuWidth)
    .borderRadius(StyleConstants.DEFAULT_12)
  }
}

@Component
struct HorizontalMenuItem {
  @State shortcutIcon: string | image.PixelMap = StyleConstants.DEFAULT_ICON;
  @State shortcutName: string = '';
  @State hoverState: boolean = false;
  @State pressState: boolean = false;
  closeMenu: Function = () => {};
  private mResourceManager: ResourceManager = ResourceManager.getInstance();
  private isPc: boolean = DeviceHelper.isPC();
  menuInfo: MenuInfo = new MenuInfo();
  menuMode: number = CommonConstants.MENU_UI_MODE_LIGHT;
  menuWidth: number = 0;

  public aboutToAppear(): void {
    this.mResourceManager = ResourceManager.getInstance();
    this.updateIcon();
    this.updateName();
  }

  public shortcutIconLoadCallback(image: string | PixelMap) {
    this.shortcutIcon = image;
  }

  public shortcutNameLoadCallback(name: string) {
    this.shortcutName = name;
  }

  public updateIcon() {
    if (this.menuInfo.shortcutIconId != -1 && this.menuInfo.menuImgSrc != '' && this.menuInfo.menuImgSrc != null) {
      IconResourceManager.getInstance()
        .getCombIcon(this.menuInfo.bundleName, this.menuInfo.moduleName)
        .then((iconResource: string | PixelMap) => {
          this.shortcutIconLoadCallback(iconResource)
        });
    } else {
      this.shortcutIconLoadCallback(this.menuInfo.menuImgSrc as (string | PixelMap));
    }
  }

  public updateName() {
    if (this.menuInfo.shortcutLabelId != -1 && this.menuInfo.menuText != '' && this.menuInfo.menuText != null) {
      IconResourceManager.getInstance().getAppNameWithCallback(this.menuInfo.shortcutLabelId,
        this.menuInfo.bundleName as string, this.menuInfo.moduleName as string, this.shortcutName,
        (name: string): void =>
         this.shortcutNameLoadCallback(name));
    } else {
      this.shortcutNameLoadCallback(this.menuInfo.menuText as string);
    }
  }

  getItemBackgroundColor() {
    if (this.hoverState) {
      return $r('sys.color.ohos_id_color_hover');
    }
    if (this.pressState) {
      return $r('sys.color.ohos_id_color_click_effect');
    }
    return StyleConstants.DEFAULT_TRANSPARENT_COLOR;
  }

  // 计算文本框剩余最大宽度
  computeMaxTextWidth(): number {
    if (!this.isPc) {
      return this.menuWidth - StyleConstants.DEFAULT_60;
    } else {
      return this.menuWidth - StyleConstants.DEFAULT_60 - StyleConstants.DEFAULT_18;
    }
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center
    }) {
      if (this.shortcutIcon != null && this.shortcutIcon != '') {
        Image(this.shortcutIcon).draggable(false)
          .objectFit(ImageFit.Contain)
          .height(!this.isPc ? StyleConstants.MENU_IMAGE_HEIGHT_PHONE : StyleConstants.MENU_IMAGE_HEIGHT_PC)
          .width(!this.isPc ? StyleConstants.MENU_IMAGE_WIDTH_PHONE : StyleConstants.MENU_IMAGE_WIDTH_PC)
          .fillColor($r('sys.color.ohos_id_color_secondary'))
          .id('HorizontalMenuItem_Image_shortCut')
          .flexShrink(0)
      } else {
        Image('').draggable(false)
          .id('HorizontalMenuItem_Image_empty')
          .objectFit(ImageFit.Contain)
          .height(!this.isPc ? StyleConstants.MENU_IMAGE_HEIGHT_PHONE : StyleConstants.MENU_IMAGE_HEIGHT_PC)
          .width(!this.isPc ? StyleConstants.MENU_IMAGE_WIDTH_PHONE : StyleConstants.MENU_IMAGE_WIDTH_PC)
          .fillColor($r('sys.color.ohos_id_color_secondary'))
          .flexShrink(0)
      }
      Text(this.shortcutName).draggable(false)
        .id('HorizontalMenuItem_Text_shortCutName')
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontWeight(FontWeight.Regular)
        .flexGrow(StyleConstants.DEFAULT_1)
        .flexShrink(StyleConstants.DEFAULT_1)
        .margin({
          start: !this.isPc ? LengthMetrics.vp(StyleConstants.DEFAULT_12) : LengthMetrics.vp(StyleConstants.DEFAULT_16)
        })
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxFontScale(StyleConstants.FONT_MAX_SCALE_FORM_TEXT)
    }
    .border({
      radius: !this.isPc ? StyleConstants.MENU_EXTERNAL_RADIUS - StyleConstants.DEFAULT_4 :
        StyleConstants.POPUP_MENU_HOVER_RADIUS_10
    })
    .id('HorizontalMenuItem_Flex_parent')
    .padding({
      start: LengthMetrics.vp(!this.isPc ? StyleConstants.DEFAULT_12 : StyleConstants.DEFAULT_18),
      end: LengthMetrics.vp(!this.isPc ? StyleConstants.DEFAULT_12 : StyleConstants.DEFAULT_18),
      top: LengthMetrics.vp(StyleConstants.DEFAULT_4),
      bottom: LengthMetrics.vp(StyleConstants.DEFAULT_4),
    })
    .constraintSize({
      minHeight: !this.isPc ? StyleConstants.DEFAULT_44 : StyleConstants.DEFAULT_56,
    })
    .width(this.menuWidth)
    .onClick(() => {
      this.menuInfo?.onMenuClick?.();
      this.closeMenu();
      ContextMenu.close();
      localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);
      this.hoverState = false;
      this.pressState = false;
    })
    .backgroundColor(this.getItemBackgroundColor())
    .onHover((isHover?: boolean): void => {
      this.hoverState = isHover as boolean;
    })
    .onTouch((event?: TouchEvent): void => {
      if (event?.type === TouchType.Down) {
        this.pressState = true;
      }
      if (event?.type === TouchType.Up) {
        this.pressState = false;
      }
    })
    .onMouse((event?: MouseEvent): void => {
      if (event?.button == MouseButton.Left && event?.action == MouseAction.Press) {
        this.hoverState = false;
        this.pressState = true;
      } else if (event?.button == MouseButton.Left && event?.action == MouseAction.Release) {
        this.pressState = false;
      }
    })
  }
}