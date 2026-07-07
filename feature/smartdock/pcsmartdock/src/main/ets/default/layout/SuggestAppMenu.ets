/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { ResourceManager, IconResourceManager, localEventManager } from '@ohos/frameworkwrapper';
import {
  CommonConstants, MenuInfo, StyleConstants, EventConstants, AppModel
} from '@ohos/launchercommon';
import measure from '@ohos.measure';
import { LengthMetrics } from '@kit.ArkUI';
import image from '@ohos.multimedia.image';
import SuggestMenuModel from '../model/SuggestMenuModel';
import { FixedDockResource } from '../common/constants/FixedDockConstants';

const TAG = 'SuggestAppMenu';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);
const MENU_KEY = 'h1_launcher_common_uicomponents_suggestAppMenu';
const OPEN_KEY = 'h1_launcher_common_uicomponents_suggestAppMenu_open';
const NAME_SIZE = 16;

@Component
export struct SuggestAppMenu {
  private minSuggestMenuTextWidth: number = 108;
  private menuOnAppear: Function = () => {
  };
  private menuOnDisAppear: Function = () => {
  };
  private mAppModel: AppModel = AppModel.getInstance();
  menuInfoList: Array<MenuInfo> = [];
  closeMenu: Function = () => {
  };
  minTextWidth?: number;
  private ratio: number = 1;
  @StorageLink('fixedMenuList') fixedMenuList: Array<MenuInfo> = [];
  @StorageLink('dynamicMenuList') dynamicMenuList: Array<MenuInfo> = [];
  @StorageLink('isBothTypeMenuExist') isBothTypeMenuExist: boolean = true;
  @Provide suggestMenuTextWidth: number = StyleConstants.MENU_FONTSIZE;
  @Prop screenId: number = 0;

  aboutToAppear() {
    log.showInfo('Launcher AppMenu aboutToAppear start');
    this.menuInfoList = SuggestMenuModel.getInstance().getSuggestMenuInfoList(this.screenId);
    this.initAppInfo();
    if (CheckEmptyUtils.isEmpty(this.minTextWidth)) {
      this.suggestMenuTextWidth = StyleConstants.MENU_FONTSIZE;
    } else {
      this.suggestMenuTextWidth = this.minSuggestMenuTextWidth;
    }
    AppStorage.setOrCreate('isLongPress', true);
    this.menuOnAppear();
  }

  aboutToDisappear() {
    this.menuOnDisAppear();
  }

  private initAppInfo(): void {
    this.menuInfoList.forEach((item) => {
      const appInfoItem = this.mAppModel.getAppInfoByBundleName(item.bundleName);
      if (item.menuType !== CommonConstants.MENU_TYPE_FIXED && item?.shortcutLabelId !== appInfoItem?.appLabelId) {
        item.shortcutLabelId = appInfoItem?.appLabelId as number;
        item.menuText = appInfoItem?.appName ?? '';
        log.showInfo(`update menuType: ${item.menuType} name: ${item.menuText} shortcutLabelId ${item?.shortcutLabelId}`);
      }
    });
  }

  @Builder
  menuTitleBuilder() {
    Column() {
      Text($r('app.string.app_dock_menu_suggest_title'))
        .draggable(false)
        .id(`ResidentLayoutForPC_Text_menuSuggestTitle`)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontSize(FixedDockResource.DOCK_MENU_SUB_TITLE_SIZE * this.ratio)
        .fontWeight(FontWeight.Medium)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({
          left: StyleConstants.DEFAULT_12
        })
    }
    .height(StyleConstants.DEFAULT_40 * this.ratio)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  menuItemBuilder() {
    Column({ space: StyleConstants.DEFAULT_2 }) {
      ForEach(this.dynamicMenuList, (item: MenuInfo, index?: number) => {
        HorizontalMenuItem({
          menuInfo: item,
          closeMenu: this.closeMenu,
          index: index,
          ratio: this.ratio,
          lastIndex: this.dynamicMenuList.length - 1,
          needShowImage: true,
          menuOnDisAppear: this.menuOnDisAppear,
          screenId: this.screenId
        })
          .id(`${TAG}_HorizontalMenuItem_dynamicMenu${index}`)
      }, (item: MenuInfo) => JSON.stringify(item))
    }
    .visibility(this.dynamicMenuList.length > 0 ? Visibility.Visible : Visibility.None)
  }

  @Builder
  separatorBuilder() {
    Row() {
      Divider()
        .vertical(false)
        .color($r('sys.color.ohos_id_color_list_separator'))
        .strokeWidth('1px')
        .margin({
          left: StyleConstants.DEFAULT_12,
          right: StyleConstants.DEFAULT_12,
        })
    }
    .height(StyleConstants.DEFAULT_9 * this.ratio)
    .padding({
      top: StyleConstants.MENU_MARGIN * this.ratio,
      bottom: StyleConstants.MENU_MARGIN * this.ratio
    })
    .visibility(this.isBothTypeMenuExist ? Visibility.Visible : Visibility.None)
  }

  @Builder
  menuOpenBuilder() {
    Column({ space: StyleConstants.DEFAULT_2 }) {
      ForEach(this.fixedMenuList, (item: MenuInfo, index?: number) => {
        HorizontalMenuItem({
          menuInfo: item,
          closeMenu: this.closeMenu,
          index: index,
          ratio: this.ratio,
          lastIndex: this.dynamicMenuList.length - 1,
          needShowImage: false,
          menuOnDisAppear: this.menuOnDisAppear,
          screenId: this.screenId
        })
          .id(`${TAG}_HorizontalMenuItem_fixedMenu${index}`)
      }, (item: MenuInfo) => JSON.stringify(item))
    }.key(OPEN_KEY)
    .visibility(this.fixedMenuList.length > 0 ? Visibility.Visible : Visibility.None)
  }

  build() {
    Menu() {
      if (this.menuInfoList?.length > 1) {
        this.menuTitleBuilder();
      }
      this.menuItemBuilder();
      this.separatorBuilder();
      this.menuOpenBuilder();
    }.key(MENU_KEY)
    .width((this.suggestMenuTextWidth + StyleConstants.DEFAULT_52) * this.ratio)
    .borderRadius(StyleConstants.DEFAULT_8 * this.ratio)
    .padding({
      top: (StyleConstants.MENU_MARGIN + 0.5) * this.ratio,
      bottom: (StyleConstants.MENU_MARGIN + 0.5) * this.ratio,
      left: StyleConstants.MENU_MARGIN * this.ratio,
      right: StyleConstants.MENU_MARGIN * this.ratio,
    })
  }
}

@Component
struct HorizontalMenuItem {
  closeMenu: Function = () => {
  };
  private mResourceManager: ResourceManager = ResourceManager.getInstance();
  private menuInfo: MenuInfo = new MenuInfo();
  private menuOnDisAppear: Function = () => {
  };
  index: number = 0;
  lastIndex: number = 0;
  private ratio: number = 1;
  @State needShowImage: boolean = true;
  @State shortcutIcon: string | image.PixelMap = StyleConstants.DEFAULT_ICON;
  @State shortcutName: string = '';
  @State isHovered: boolean = false;
  @State pressState: boolean = false;
  @Consume suggestMenuTextWidth: number;
  @StorageProp('systemLanguage') @Watch('onLanguageChange') systemLanguage: string = '';
  @Prop screenId: number = 0;

  public shortcutIconLoadCallback(image: string | image.PixelMap): void {
    this.shortcutIcon = image;
  }

  public shortcutNameLoadCallback(name: string): void {
    this.shortcutName = name;
    this.setTextWidth();
    log.showInfo(`bundleName: ${this.menuInfo.bundleName}, appName: ${name}`);
  }

  public setTextWidth(): void {
    let needTextWidth: number = Math.round(px2vp(measure.measureText({
      textContent: this.shortcutName,
      fontSize: StyleConstants.MENU_FONTSIZE,
      fontWeight: FontWeight.Regular,
      overflow: TextOverflow.Ellipsis,
      maxLines: 1
    }))) + StyleConstants.DEFAULT_12;
    this.suggestMenuTextWidth = needTextWidth > this.suggestMenuTextWidth ? needTextWidth : this.suggestMenuTextWidth;
  }

  public onLanguageChange(): void {
    log.showDebug(`suggestAppMenu onLanguageChange:${this.systemLanguage} menuText:${this.menuInfo?.menuText}`);
    this.mResourceManager?.getAppNameWithCache(this.menuInfo?.shortcutLabelId, this.menuInfo?.bundleName as string,
      this.menuInfo?.moduleName as string,
      this.shortcutName,
      (name: string): void => this.shortcutNameLoadCallback(name));
  }

  public updateIcon() {
    if (this.menuInfo?.shortcutIconId != -1 && this.menuInfo?.menuImgSrc != '' && this.menuInfo?.menuImgSrc != null) {
      IconResourceManager.getInstance()
        .getCombIcon(this.menuInfo?.bundleName, this.menuInfo?.moduleName, this.menuInfo?.menuAbility)
        .then((iconResource: string | PixelMap) => {
          // 如果获取到的图标为空，使用menuImgSrc作为备用图标
          if (iconResource === null || iconResource === undefined ||
            (typeof iconResource === 'object' && CheckEmptyUtils.isEmptyPixelMap(iconResource as image.PixelMap))) {
            log.showWarn(`getCombIcon return empty, use menuImgSrc as fallback,
              bundleName: ${this.menuInfo?.bundleName}`);
            this.shortcutIconLoadCallback(this.menuInfo?.menuImgSrc as (string | PixelMap));
          } else {
            this.shortcutIconLoadCallback(iconResource);
          }
        })
        .catch((error: Error) => {
          log.showError(`getCombIcon failed, use menuImgSrc as fallback,
            bundleName: ${this.menuInfo?.bundleName}, error: ${error}`);
          this.shortcutIconLoadCallback(this.menuInfo?.menuImgSrc as (string | PixelMap));
        });
    } else {
      this.shortcutIconLoadCallback(this.menuInfo?.menuImgSrc as (string | PixelMap));
    }
  }

  public updateName(): void {
    if (this.menuInfo?.shortcutLabelId != -1) {
      this.mResourceManager?.getAppNameWithCache(this.menuInfo?.shortcutLabelId, this.menuInfo?.bundleName as string,
        this.menuInfo?.moduleName as string, this.shortcutName,
        (name: string): void => this.shortcutNameLoadCallback(name));
    } else {
      this.shortcutNameLoadCallback(this.menuInfo?.menuText as string);
    }
  }

  private getItemBackgroundColor(): Resource | string {
    if (this.isHovered) {
      return $r('sys.color.ohos_id_color_hover');
    }
    if (this.pressState) {
      return $r('sys.color.ohos_id_color_click_effect');
    }
    return StyleConstants.DEFAULT_TRANSPARENT_COLOR;
  }

  aboutToAppear() {
    this.updateIcon();
    this.updateName();
    this.isHovered = false;
    this.pressState = false;
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center
    }) {
      if (this.needShowImage && this.shortcutIcon != null && this.shortcutIcon != '') {
        Image(this.shortcutIcon)
          .draggable(false)
          .id(`${TAG}_Image_${this.menuInfo?.bundleName}`)
          .objectFit(ImageFit.Contain)
          .height(StyleConstants.MENU_IMAGE_HEIGHT_PC * this.ratio)
          .width(StyleConstants.MENU_IMAGE_WIDTH_PC * this.ratio)
          .interpolation(ImageInterpolation.Medium)
          .margin({
            left: StyleConstants.DEFAULT_12 * this.ratio
          })
          .border({
            width: StyleConstants.POPUP_IMAGE_BORDER_WIDTH * this.ratio,
            radius: StyleConstants.POPUP_IMAGE_BORDER_RADIUS * this.ratio,
            color: this.menuInfo?.menuType === CommonConstants.MENU_TYPE_FIXED ?
              StyleConstants.DEFAULT_TRANSPARENT_COLOR : StyleConstants.POPUP_IMAGE_BORDER_COLOR
          })
      } else if (this.needShowImage) {
        Image('')
          .draggable(false)
          .id(`${TAG}_Image_nullShortCut`)
          .objectFit(ImageFit.Contain)
          .fillColor($r('sys.color.ohos_id_color_text_primary'))
          .height(StyleConstants.MENU_IMAGE_HEIGHT_PC * this.ratio)
          .width(StyleConstants.MENU_IMAGE_WIDTH_PC * this.ratio)
          .backgroundColor('#33ffffFF')
          .margin({
            left: StyleConstants.DEFAULT_12 * this.ratio
          })
      }
      Text(this.shortcutName)
        .draggable(false)
        .id(`${TAG}_Text_${this.menuInfo?.bundleName}`)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize(NAME_SIZE * this.ratio)
        .fontWeight(FontWeight.Regular)
        .height(StyleConstants.DEFAULT_40 * this.ratio)
        .width(this.suggestMenuTextWidth * this.ratio)
        .margin({
          left: StyleConstants.DEFAULT_12 * this.ratio
        })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .borderRadius(StyleConstants.POPUP_MENU_HOVER_RADIUS)
    .height(StyleConstants.DEFAULT_40 * this.ratio)
    .width((this.suggestMenuTextWidth + StyleConstants.DEFAULT_44) * this.ratio)
    .onClick(() => {
      if (this.menuInfo?.onMenuClick) {
        this.menuInfo?.onMenuClick(this.screenId);
      }
      this.closeMenu();
      ContextMenu.close();
      localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);
      this.isHovered = false;
      this.pressState = false;
      this.menuOnDisAppear();
    })
    .focusBox({
      margin: new LengthMetrics(0)
    })
    .backgroundColor(this.getItemBackgroundColor())
    .onHover((isHover?: boolean): void => {
      this.isHovered = isHover as boolean;
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
      if (event?.button === MouseButton.Left && event?.action === MouseAction.Press) {
        this.isHovered = false;
        this.pressState = true;
      } else if (event?.button === MouseButton.Left && event?.action === MouseAction.Release) {
        this.pressState = false;
      }
    })
  }
}