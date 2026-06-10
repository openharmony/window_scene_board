/*
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

import { image } from '@kit.ImageKit';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { AppItemInfo } from '../../bean/AppItemInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import GridLayoutUtil from '../../utils/GridLayoutUtil';
import { ShortcutViewModel } from '../viewmodel/ShortcutViewModel';

const TAG = 'AppIconBaseCanvas';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

export class AppIconBaseCanvas {
  private canvasContext?: CanvasRenderingContext2D;
  private canvasId: string = '';
  private fillStyle: string = '';

  constructor(settings: RenderingContextSettings, canvasId: string, fillStyle: string) {
    if (!settings || CheckEmptyUtils.checkStrIsEmpty(canvasId) || CheckEmptyUtils.checkStrIsEmpty(fillStyle)) {
      log.showError(`init AppIconLongPressCanvas failed, ` +
        `settings ${!RenderingContextSettings} or canvasId(${canvasId}) or fillStyle(${fillStyle}) is invalid!`);
      return;
    }

    this.canvasContext = new CanvasRenderingContext2D(settings);
    this.canvasId = canvasId;
    this.fillStyle = fillStyle;
  }

  /**
   * 设置canvas填充颜色
   *
   * @param fillStyle mask style
   */
  public setFillStyle(fillStyle: string): void {
    this.fillStyle = fillStyle;
  }

  /**
   * 绘制蒙层
   *
   * @param context CanvasRenderingContext2D
   * @param fillStyle mask style
   * @param iconSize 图标大小
   */
  public updateMask(image: string | image.PixelMap, iconSize: number, item: AppItemInfo): void {
    if (!this.canvasContext) {
      log.showError('drawMask failed, canvasContext is invalid!');
      return;
    }
    log.showInfo(`update canvas mask: ${this.canvasId}, iconSize: ${iconSize}`);

    // 蒙层绘制稍微扩宽, 避免蒙层不能完全遮罩
    // hds图片与image组件宽高px单位一致, 为了保证图标不漏白边, 蒙层绘制向外新增1px保证视觉效果
    let tempIconSize: number = iconSize + px2vp(1);

    // 正在下载的应用图标和四叶草图标直接画一个方形蒙层
    if (typeof image === 'string' && !GridLayoutUtil.isAppInstalled(item)) {
      this.canvasContext.save();
      this.canvasContext.clearRect(0, 0, tempIconSize, tempIconSize);
      this.canvasContext.fillStyle = this.fillStyle;
      this.canvasContext.fillRect(0, 0, tempIconSize, tempIconSize);
      this.canvasContext.restore();
      return;
    }

    let tempImg: image.PixelMap = image as PixelMap;
    // 空图标、快捷图标的蒙层基于快捷图标背景图绘制
    if (CheckEmptyUtils.isEmptyPixelMap(tempImg) || item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      let tempItem: AppItemInfo = new AppItemInfo();
      tempItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      tempImg = ShortcutViewModel.getInstance().getShortcutBackgroundImage(tempItem) as PixelMap;
    }

    this.canvasContext.save();
    this.canvasContext.clearRect(0, 0, tempIconSize, tempIconSize);
    this.canvasContext.drawImage(tempImg, 0, 0, tempIconSize, tempIconSize);
    this.canvasContext.globalCompositeOperation = 'source-in';
    this.canvasContext.fillStyle = this.fillStyle;
    this.canvasContext.fillRect(0, 0, tempIconSize, tempIconSize);
    this.canvasContext.restore();
  }

  public getCanvasId(): string {
    return this.canvasId;
  }

  public getContext(): CanvasRenderingContext2D {
    return this.canvasContext as CanvasRenderingContext2D;
  }
}