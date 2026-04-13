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

import image from '@ohos.multimedia.image';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { PluginAccessInfo, PluginIconChangeEvent, EventManager, EvtBus } from '@ohos/frameworkwrapper';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/constants/StyleConstants';
import { StatusBarType } from '@ohos/systemuicommon';
import { StatusBarTint } from '../../common/StatusBarTint';
import { PluginProperty } from '../viewdata/PluginProperty';
// import { hdsDrawable } from '@kit.UIDesignKit';

const TAG = 'PcAccessPluginComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 本应用内plugin组件
 *
 * @since 2024-03-14
 */
@Component
export struct PcAccessPluginComponent {
  @ObjectLink property: PluginProperty;
  @Consume @Watch('onColorChange') contentColor: string;
  /**
   * 图标默认宽度
   */
  @State icon: image.PixelMap | undefined = undefined;
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  private setIcon(): void {
    let icons = this.getPluginInfo()?.icon;
    let bundleName = this.getPluginInfo().pluginParseInfo.bundleName;
    const whiteIconInfo = icons?.white?.getImageInfoSync();
    const blackIconInfo = icons?.white?.getImageInfoSync();
    log.showInfo(`setIcon contentColor: ${this.contentColor}, ` +
      `whiteIconInfo: ${JSON.stringify(whiteIconInfo)}, blackIconInfo: ${JSON.stringify(blackIconInfo)}`);
    if (this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE) {
      this.icon = this.getHdsIcon(bundleName, icons?.white, StyleConstants.PC_STATUS_BAR_ACCESS_ICON_SIZE);
    } else {
      this.icon = this.getHdsIcon(bundleName, icons?.black, StyleConstants.PC_STATUS_BAR_ACCESS_ICON_SIZE);
    }
  }

  private onColorChange(): void {
    log.showInfo('onColorChange');
    this.setIcon();
  }

  private getHdsIcon(bundleName: string, pixelMap: image.PixelMap | undefined, size: number):
  image.PixelMap | undefined {
    if (!pixelMap) {
      log.error('pixelMapToPixelMap error: base64Str to pixelMap error');
      return;
    }
    let backgroundImage: image.PixelMap | undefined = pixelMap;
    // pixelMap格式转换 HDS仅支持BGRA_8888
    let newPixelMap: image.PixelMap | undefined = undefined;
    try {
      const buffer: ArrayBuffer = new ArrayBuffer(pixelMap.getPixelBytesNumber());
      pixelMap.readPixelsToBufferSync(buffer);
      let opts: image.InitializationOptions = {
        pixelFormat: image.PixelMapFormat.BGRA_8888,
        size: pixelMap.getImageInfoSync().size,
        srcPixelFormat: pixelMap.getImageInfoSync().pixelFormat
      }
      newPixelMap = image.createPixelMapSync(buffer, opts);
      log.showInfo(`pixelMapToPixelMap newPixelMap: ${JSON.stringify(newPixelMap?.getImageInfoSync())}, bundleName: ${bundleName}`);
      // mask为null, hds会从resourcemanager取
      // let hdsIcon:ESObject = hdsDrawable.getHdsIcon(bundleName, newPixelMap, size, null);
      // if (hdsIcon) {
      //   backgroundImage = hdsIcon;
      //   log.showInfo(`hdsIcon: ${JSON.stringify(hdsIcon.getImageInfoSync())}`);
      // }
    } catch (err) {
      log.showError(`pixelMapToPixelMap error:  ${err?.message}, code: ${err?.code}`);
    } finally {
      if (newPixelMap) {
        newPixelMap.release();
      }
    }
    return backgroundImage;
  }

  private getPluginInfo(): PluginAccessInfo {
    return this.property.pluginInfo as PluginAccessInfo;
  }

  aboutToAppear() {
    this.setIcon();
    this.eventMgr.on(PluginIconChangeEvent, this.onPluginIconChange, this.property.getSlot() ?? '');
  }

  aboutToDisappear(): void {
    this.eventMgr.offAll();
  }

  private onPluginIconChange = (event: PluginIconChangeEvent) => {
    let info = this.getPluginInfo();
    if (!info || !event) {
      log.showError('onPluginIconChange invalid');
      return;
    }
    if (event.tokenId === info.accessTokenId && event.instanceKey === info.pluginParseInfo.instanceKey) {
      this.setIcon();
    }
  }

  buildLog(): boolean {
    log.showInfo('slot: ' + this.property.getSlot() +
      ',icon: ' + JSON.stringify(this.icon) + ',pluginInfo: ' + JSON.stringify(this.getPluginInfo()));
    return true;
  }

  build() {
    if (this.property.pluginInfo && this.icon && this.buildLog()) {
      Row() {
        Image(this.icon)
          .draggable(false)
          .id(this.property.getSlot())
          .width(StyleConstants.PC_STATUS_BAR_ACCESS_ICON_SIZE)
          .height(StyleConstants.PC_STATUS_BAR_ACCESS_ICON_SIZE)
          .objectFit(ImageFit.Contain)
          .syncLoad(true)
          .interpolation(ImageInterpolation.Medium)
          .autoResize(false)
      }
      .width('100%')
      .height('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center);
    }
  }
}