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

import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils';
import { ResourceManager, localEventManager } from '@ohos/frameworkwrapper';
import { MenuInfo, StyleConstants, EventConstants, CommonConstants } from '@ohos/launchercommon';
import { FixedDockResource } from '../common/constants/FixedDockConstants';
import { LengthMetrics, MeasureUtils } from '@kit.ArkUI';
import { resourceManager } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import image from '@ohos.multimedia.image';
import { DockMenuTaskInfo } from '../bean/DockMenuTaskInfo';
import { PcDockPopupMgr } from '../manager/PcDockPopupMgr';

const TAG = 'PCDock-DockMenuItem';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

const POPUP_TIP_SHOW_DELAY = 700;

@Component
export struct DockMenuItem {
  screenId: number = 0;
  appParams?: Map<string, Object>;
  menuInfo: MenuInfo = new MenuInfo();
  closeMenu: Function = () => {
  };
  private mResourceManager: ResourceManager = ResourceManager.getInstance();
  menuOnDisAppear: Function | undefined = undefined;
  deleteTaskCallback: Function | undefined = undefined;
  menuTaskInfo: DockMenuTaskInfo | undefined = undefined;
  private bodyL: number = this.getNumberByResource($r('sys.float.Body_L'), 16);
  private bodyM: number = this.getNumberByResource($r('sys.float.Body_M'), 14);
  @State shortcutIcon: string = StyleConstants.DEFAULT_ICON;
  @State shortcutName: string = '';
  @State private hoverState: boolean = false;
  @State private pressState: boolean = false;
  @State isEnable: boolean = true;
  @Consume dockMenuTextWidth: number;
  @Consume dockMenuImgWidth: number;
  @State private popupShow: boolean = false;
  private ratio: number = 1;
  private uiContextMeasure: MeasureUtils = this.getUIContext().getMeasureUtils();
  private hoverTipsTimer: number | undefined;
  private menuImgSrc: image.PixelMap | undefined = undefined;

  @State closePicBackgroundColor: Resource | null = null;

  private getNumberByResource(resource: Resource, defaultValue: number): number {
    try {
      let sourceValue: number = resourceManager.getSystemResourceManager().getNumber(resource);
      if (sourceValue > 0) {
        return sourceValue;
      } else {
        return defaultValue;
      }
    } catch (error) {
      let code: number = (error as BusinessError).code;
      let message: string = (error as BusinessError).message;
      log.showError(TAG, `getNumberByResource error, code: ${code}, message: ${message}`);
      return defaultValue;
    }
  }

  aboutToAppear(): void {
    this.menuImgSrc = this.menuInfo.menuImgSrc as image.PixelMap;
    this.updateName();
    log.showInfo(TAG, `aboutToAppear`);
  }

  private shortcutNameLoadCallback(name: string): void {
    this.shortcutName = name;
    this.setTextWidth();
  }

  private setTextWidth(): void {
    let needTextWidth: number = Math.round(px2vp(this.uiContextMeasure.measureText({
      textContent: this.shortcutName,
      fontSize: StyleConstants.MENU_FONTSIZE,
      fontWeight: FontWeight.Regular,
      overflow: TextOverflow.Ellipsis,
      maxLines: 1
    }))) + StyleConstants.DEFAULT_12;
    this.dockMenuTextWidth = needTextWidth > this.dockMenuTextWidth ? needTextWidth : this.dockMenuTextWidth;
    if (this.menuInfo.menuType === CommonConstants.MENU_TYPE_TASK && this.dockMenuImgWidth === 0) {
      this.dockMenuImgWidth = StyleConstants.MENU_IMAGE_WIDTH_PC + StyleConstants.DEFAULT_8;
    }
  }

  private updateName(): void {
    if (this.menuInfo.shortcutLabelId != -1 && this.menuInfo.menuText != '' && this.menuInfo.menuText != null) {
      this.mResourceManager.getAppNameWithCache(this.menuInfo.shortcutLabelId, this.menuInfo.bundleName,
        this.menuInfo.moduleName, this.shortcutName, (name: string): void => this.shortcutNameLoadCallback(name));
    } else {
      this.shortcutNameLoadCallback(this.menuInfo.menuText as string);
    }
  }

  private getItemBackgroundColor(): Resource | string {
    if (!this.isEnable) {
      return StyleConstants.DEFAULT_TRANSPARENT_COLOR;
    }
    if (this.pressState) {
      return $r('sys.color.ohos_id_color_click_effect');
    }
    if (this.hoverState) {
      return $r('sys.color.ohos_id_color_hover');
    }
    return StyleConstants.DEFAULT_TRANSPARENT_COLOR;
  }

  private getItemOpacity(): number | Resource {
    if (this.isEnable) {
      return 1;
    } else {
      return $r('sys.float.ohos_id_alpha_disabled');
    }
  }

  private closeHoverTips(): void {
    this.popupShow = false;
    if (this.hoverTipsTimer) {
      clearTimeout(this.hoverTipsTimer);
    }
  }

  private updateHoverTips(isHovered: boolean): void {
    log.showInfo(TAG, `this.menuInfo hoverTips:${this.menuInfo.hoverTips} isHovered:${isHovered}`);
    if (CheckEmptyUtils.isEmpty(this.menuInfo.hoverTips)) {
      return;
    }
    if (this.hoverTipsTimer) {
      clearTimeout(this.hoverTipsTimer);
      this.hoverTipsTimer = undefined;
    }
    if (isHovered) {
      this.hoverTipsTimer = setTimeout(() => {
        log.showInfo(TAG, `updateHoverTips: ${this.menuInfo.hoverTips}`);
        this.popupShow = true;
      }, POPUP_TIP_SHOW_DELAY);
    } else {
      log.showInfo(TAG, `this.menuInfo hide popup tips`);
      this.popupShow = false;
    }
  }

  private isShowCloseButton(): boolean {
    return this.hoverState;
  }

  private getTextWidth(labelName: string, size: Resource, defaultRadius: number = StyleConstants.DEFAULT_16): number {
    let needTextWidth: number = Math.ceil(px2vp(this.uiContextMeasure.measureTextSize({
      textContent: labelName,
      fontSize: size,
      fontWeight: FontWeight.Regular,
      overflow: TextOverflow.Ellipsis
    }).width as number)) + defaultRadius;
    return needTextWidth;
  }

  private calcShowTipsWidth(): number {
    if (!this.menuInfo.hoverTips) {
      log.showWarn(TAG, 'hoverTips is empty');
      return 0;
    }
    const textWidth = this.getTextWidth(this.menuInfo.hoverTips, $r('sys.float.Body_M'));
    const maxTextWidth = FixedDockResource.DOCK_MENU_MAX_WIDTH;
    return textWidth > maxTextWidth ? maxTextWidth : textWidth;
  }

  @Builder
  showTipsBuilder() {
    Row() {
      Text(this.menuInfo.hoverTips)
        .id(`PreviewImageLabelName_Text_${this.menuTaskInfo?.taskId}`)
        .fontSize(this.bodyM * this.ratio)
        .fontColor($r('sys.color.font_primary'))
    }
    .width(this.calcShowTipsWidth() * this.ratio)
    .padding(StyleConstants.DEFAULT_8 * this.ratio)
  }

  @Builder
  closeButtonBuilder() {
    Stack({ alignContent: Alignment.Center }) {
      SymbolGlyph($r('sys.symbol.xmark'))
        .draggable(false)
        .id(`${TAG}_Image_closePic`)
        .fontColor([$r('sys.color.ohos_id_color_primary')])
        .fontSize('16vp')
    }
    .backgroundColor(this.closePicBackgroundColor)
    .width(FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE)
    .height(FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE)
    .flexShrink(0)
    .borderRadius(StyleConstants.DEFAULT_4 * this.ratio)
    .responseRegion({
      x: '-33%',
      y: '-33%',
      width: '167%',
      height: '167%'
    })
    .onClick((event?: ClickEvent) => {
      this.deleteTaskCallback?.(this.menuTaskInfo);
    })
    .onTouch((event?: TouchEvent) => {
      if (event?.type === TouchType.Down) {
        this.closePicBackgroundColor = $r('sys.color.ohos_id_color_click_effect');
      } else if (event?.type === TouchType.Up) {
        this.closePicBackgroundColor = $r('sys.color.ohos_id_color_hover');
      }
    })
    .onHover((isHover: boolean) => {
      this.closePicBackgroundColor = isHover ? $r('sys.color.ohos_id_color_hover') : null;
    })
    .visibility(this.isShowCloseButton() ? Visibility.Visible : Visibility.None)
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center
    }) {
      if (this.menuInfo.menuType === CommonConstants.MENU_TYPE_TASK) {
        Image(this.menuImgSrc)
          .width(StyleConstants.MENU_IMAGE_WIDTH_PC * this.ratio)
          .height(StyleConstants.MENU_IMAGE_HEIGHT_PC * this.ratio)
          .objectFit(ImageFit.Contain)
          .flexShrink(0)
          .margin({ right: 8 })
      }
      Text(this.shortcutName)
        .draggable(false)
        .id(`${TAG}_Text_shortCutName`)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize(this.ratio * this.bodyL)
        .fontWeight(FontWeight.Regular)
        .maxLines(1)
        .width(this.dockMenuTextWidth * this.ratio)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      if (this.menuInfo.menuType === CommonConstants.MENU_TYPE_TASK) {
        this.closeButtonBuilder()
      }
    }
    .padding({
      top: FixedDockResource.TIPS_TEXT_PADDING,
      left: StyleConstants.DEFAULT_12 * this.ratio,
      right: StyleConstants.DEFAULT_12 * this.ratio
    })
    .borderRadius(StyleConstants.DEFAULT_4 * this.ratio)
    .height(StyleConstants.DEFAULT_40 * this.ratio)
    .width('100%')
    .focusBox({
      margin: new LengthMetrics(0)
    })
    .onClick((event: ClickEvent) => {
      if (!this.isEnable) {
        log.showInfo(TAG, `onClick, menu disabled ${this.menuInfo?.bundleName}`);
        return;
      }
      if (!this.appParams) {
        this.appParams = new Map<string, Object>();
      }
      this.appParams.set('clickEvent', event);
      this.menuInfo?.onMenuClick?.(this.appParams);
      this.closeMenu();
      ContextMenu.close();
      localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);
      PcDockPopupMgr.getInstance().setIsDockPopupShow(this.screenId, false);
      this.hoverState = false;
      this.pressState = false;
      this.closeHoverTips();
      this.menuOnDisAppear?.();
    })
    .backgroundColor(this.getItemBackgroundColor())
    .opacity(this.getItemOpacity())
    .focusable(this.isEnable)
    .bindPopup(this.popupShow, {
      builder: this.showTipsBuilder(),
      popupColor: FixedDockResource.POPUP_COLOR,
      mask: false,
      placement: Placement.Top,
      enableArrow: false,
      autoCancel: true,
      onStateChange: (event) => {
        log.showError(TAG, `onStateChange isVisible:${event.isVisible},bundleName: ${this.menuInfo.bundleName}`);
        if (!event.isVisible) {
          this.popupShow = false;
        }
      },
      showInSubWindow: true,
      followTransformOfTarget: true,
      radius: StyleConstants.DEFAULT_8 * this.ratio,
      shadow: ShadowStyle.OUTER_DEFAULT_SM,
      backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR
    })
    .onHover((isHover?: boolean) => {
      if (!this.isEnable) {
        log.showInfo(TAG, `onHover, menu disabled ${this.menuInfo?.bundleName}`);
        return;
      }
      this.hoverState = isHover as boolean;
      this.updateHoverTips(isHover ?? false);
    })
    .onTouch((event?: TouchEvent) => {
      if (event?.type === TouchType.Down) {
        this.pressState = true;
      } else if (event?.type === TouchType.Up) {
        this.pressState = false;
      }
    })
    .onMouse((event?: MouseEvent) => {
      if (!this.isEnable) {
        log.showInfo(TAG, `onMouse, menu disabled ${this.menuInfo?.bundleName}`);
        return;
      }
      if (event?.button === MouseButton.Left && event?.action === MouseAction.Press) {
        this.pressState = true;
      } else if (event?.button === MouseButton.Left && event?.action === MouseAction.Release) {
        this.pressState = false;
      }
    })
  }
}