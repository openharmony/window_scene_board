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

import lazy common2D from '@ohos.graphics.common2D';
import lazy drawing from '@ohos.graphics.drawing';
import lazy { NodeController, FrameNode, DrawContext, RenderNode } from '@ohos.arkui.node';
import lazy image from '@ohos.multimedia.image';
import lazy { RectAttr } from './StaticWallpaperManager';
import { Constants, DeviceChangeStatus } from '../utils/Constants';
import { Log } from '../utils/Log';

const TAG: string = 'WallpaperNodeController';

/**
 * 节点控制器
 *
 * @since 2024-04-29
 */
export class WallpaperNodeController extends NodeController {
  private rootNode: FrameNode | null = null;
  private renderNode?: StaticWallpaperRenderNode;
  constructor(node: StaticWallpaperRenderNode) {
    super();
    this.renderNode = node;
  }

  /**
   * 更新图片截取位置
   *
   * @param rectAttr 图片截取位置
   */
  public updateRectArr(rectAttr: Nullable<RectAttr>): void {
    this.renderNode?.updateRectArr(rectAttr ?? null) ;
  }

  /**
   * 更新路径
   *
   * @param path 图片路径
   * @param deviceChangeStatus 折叠屏折展和横竖屏状态
   */
  public updatePath(path: string, deviceChangeStatus: DeviceChangeStatus): void {
    this.renderNode?.updatePath(path, deviceChangeStatus);
  }

  /**
   * 释放图片
   */
  public releaseImage(): void {
    this.renderNode?.releaseImage();
  }

  /**
   * 创建一个独立的节点树
   *
   * @param uiContext 上下文
   * @returns 节点
   */
  public makeNode(uiContext: UIContext): FrameNode {
    Log.info(TAG, 'makeNode');
    this.rootNode = new FrameNode(uiContext);
    if (!this.renderNode) {
      return this.rootNode;
    }
    const renderNode: RenderNode | null = this.rootNode.getRenderNode();
    if (renderNode && this.renderNode) {
      this.renderNode.frame = {
        x: 0,
        y: 0,
        width: px2vp(this.renderNode.rectAttr !== null ? (this.renderNode.rectAttr.contentShowWidth ?? 0) :
          (this.renderNode.widthMap.get(this.renderNode.deviceChangeStatus) ?? 0)),
        height: px2vp(this.renderNode.rectAttr !== null ? (this.renderNode.rectAttr.contentShowHeight ?? 0) :
          (this.renderNode.heightMap.get(this.renderNode.deviceChangeStatus) ?? 0)),
      };
      renderNode.appendChild(this.renderNode);
    }
    return this.rootNode;
  }

  /**
   * drawing需要调用刷新命令进行页面刷新
   *
   * @returns 返回xController实例用于在Build中触发该方法
   */
  public refresh(): WallpaperNodeController {
    Log.info(TAG, 'refresh');
    this.renderNode?.invalidate();
    return this;
  }
}

/**
 * 用于绘制图层
 *
 * @since 2024-04-29
 */
export class StaticWallpaperRenderNode extends RenderNode {
  private pixelMaps: Map<string, image.PixelMap | null> = new Map();
  private pixelMap: image.PixelMap | null = null;
  public imgPath: string = '';
  public deviceChangeStatus: DeviceChangeStatus = DeviceChangeStatus.INVALID;
  public rectAttr: RectAttr | null =  null;
  public widthMap: Map<DeviceChangeStatus, number> = new Map([
    [DeviceChangeStatus.PORTRAIT_M2G_LAND_INVERTED, Constants.TRI_FOLD_UNFOLD_WIDTH],
    [DeviceChangeStatus.PORTRAIT_INVERTED_M2G_LAND, Constants.TRI_FOLD_UNFOLD_WIDTH],
    [DeviceChangeStatus.LAND_M2G_PORTRAIT, Constants.TRI_FOLD_UNFOLD_HEIGHT],
    [DeviceChangeStatus.LAND_INVERTED_M2G_PORTRAIT_INVERTED, Constants.TRI_FOLD_UNFOLD_HEIGHT],
    [DeviceChangeStatus.PORTRAIT_F2G_LAND_INVERTED, Constants.TRI_FOLD_BASE_WIDTH],
  ]);
  public heightMap: Map<DeviceChangeStatus, number> = new Map([
    [DeviceChangeStatus.PORTRAIT_M2G_LAND_INVERTED, Constants.TRI_FOLD_UNFOLD_HEIGHT],
    [DeviceChangeStatus.PORTRAIT_INVERTED_M2G_LAND, Constants.TRI_FOLD_UNFOLD_HEIGHT],
    [DeviceChangeStatus.LAND_M2G_PORTRAIT, Constants.TRI_FOLD_UNFOLD_WIDTH],
    [DeviceChangeStatus.LAND_INVERTED_M2G_PORTRAIT_INVERTED, Constants.TRI_FOLD_UNFOLD_WIDTH],
    [DeviceChangeStatus.PORTRAIT_F2G_LAND_INVERTED, Constants.TRI_FOLD_UNFOLD_HEIGHT],
  ]);

  /**
   * 更新图片截取位置
   *
   * @param rectAttr 图片截取位置
   */
  public updateRectArr(rectAttr: RectAttr | null): void {
    this.rectAttr = rectAttr;
  }

  /**
   * 更新路径
   *
   * @param path 图片路径
   * @param deviceChangeStatus 折叠屏折展和横竖屏状态
   */
  public updatePath(path: string, deviceChangeStatus: DeviceChangeStatus): void {
    this.imgPath = path;
    this.deviceChangeStatus = deviceChangeStatus;
  }

  /**
   * 释放图片
   */
  public releaseImage(): void {
    this.pixelMaps.forEach((pixelMap, path) => {
      pixelMap?.release();
    })
    this.pixelMap?.release();
  }

  /**
   * 绘制
   *
   * @param context 绘制上下文
   */
  public async draw(context: DrawContext): Promise<void> {
    Log.info(TAG, `draw, deviceChangeStatus: ${this.deviceChangeStatus} rectAttr: ${this.rectAttr === null}`);
    if (this.deviceChangeStatus === DeviceChangeStatus.ROTATE ||
      this.deviceChangeStatus === DeviceChangeStatus.INVALID) {
      return;
    }
    const canvas: drawing.Canvas = context.canvas;
    let shaderEffect: drawing.ShaderEffect = this.getShaderEffect();
    let brush: drawing.Brush = new drawing.Brush();
    brush.setShaderEffect(shaderEffect);
    canvas.saveLayer();
    canvas.clear(Constants.COLOR_BLACK);
    canvas.attachBrush(brush);
    let rect: common2D.Rect = {
      left: 0,
      top: 0,
      right: this.rectAttr !== null ? (this.rectAttr.contentShowWidth ?? 0) :
        (this.widthMap.get(this.deviceChangeStatus) ?? 0),
      bottom: this.rectAttr !== null? (this.rectAttr.contentShowHeight ?? 0) :
        (this.heightMap.get(this.deviceChangeStatus) ?? 0),
    };
    canvas.drawRect(rect);
    canvas.detachBrush();
    brush.setBlendMode(drawing.BlendMode.SRC_IN);
    canvas.attachBrush(brush);
    this.createPixelMap();
    if (this.pixelMap) {
      canvas.drawImageRect(this.pixelMap, rect);
    }
    canvas.restore();
  }

  private getShaderEffect(): drawing.ShaderEffect {
    if (this.rectAttr !== null) {
      return this.getShaderEffectNormalized();
    }
    return this.getShaderEffectNoneNormalized();
  }

  private getShaderEffectNoneNormalized(): drawing.ShaderEffect {
    let startPt: common2D.Point = { x: 0, y: 0 };
    let endPt: common2D.Point = { x: Constants.TRI_FOLD_UNFOLD_HEIGHT, y: 0 };
    let colors: number[] = [];
    switch (this.deviceChangeStatus) {
      case DeviceChangeStatus.PORTRAIT_M2G_LAND_INVERTED:
        colors = [Constants.COLOR_BLACK, Constants.COLOR_WHITE, Constants.COLOR_WHITE, Constants.COLOR_WHITE];
        break;
      case DeviceChangeStatus.PORTRAIT_INVERTED_M2G_LAND:
        colors = [Constants.COLOR_WHITE, Constants.COLOR_WHITE, Constants.COLOR_WHITE, Constants.COLOR_BLACK];
        break;
      case DeviceChangeStatus.LAND_M2G_PORTRAIT:
        endPt = { x: 0, y: Constants.TRI_FOLD_UNFOLD_HEIGHT };
        colors = [Constants.COLOR_BLACK, Constants.COLOR_WHITE, Constants.COLOR_WHITE, Constants.COLOR_WHITE];
        break;
      case DeviceChangeStatus.LAND_INVERTED_M2G_PORTRAIT_INVERTED:
        endPt = { x: 0, y: Constants.TRI_FOLD_UNFOLD_HEIGHT };
        colors = [Constants.COLOR_WHITE, Constants.COLOR_WHITE, Constants.COLOR_WHITE, Constants.COLOR_BLACK];
        break;
      case DeviceChangeStatus.PORTRAIT_F2G_LAND_INVERTED:
        endPt = { x: Constants.TRI_FOLD_BASE_WIDTH, y: 0 };
        colors = [Constants.COLOR_WHITE, Constants.COLOR_WHITE, Constants.COLOR_BLACK];
        break;
      default:
        Log.debug(TAG, `other status: ${this.deviceChangeStatus}`);
        break;
    }
    return drawing.ShaderEffect.createLinearGradient(startPt, endPt, colors, drawing.TileMode.CLAMP);
  }

  private getShaderEffectNormalized(): drawing.ShaderEffect {
    let offsetX: number = this.rectAttr?.contentOffsetX ?? 0;
    let offsetY: number = this.rectAttr?.contentOffsetY ?? 0;
    let height: number = this.rectAttr?.contentShowHeight ?? 0;
    let startPt: common2D.Point = { x: 0, y: 0 };
    let endPt: common2D.Point = { x: 0, y: 0 };
    let colors: number[] = [];
    switch (this.deviceChangeStatus) {
      case DeviceChangeStatus.PORTRAIT_M2G_LAND_INVERTED:
        startPt = { x: -offsetX, y: 0 };
        endPt = { x: height + offsetX, y: 0 };
        colors = [Constants.COLOR_BLACK, Constants.COLOR_WHITE, Constants.COLOR_WHITE, Constants.COLOR_WHITE];
        break;
      case DeviceChangeStatus.PORTRAIT_INVERTED_M2G_LAND:
        startPt = { x: -offsetX,  y: 0 };
        endPt = { x: height + offsetX, y: 0 };
        colors = [Constants.COLOR_WHITE, Constants.COLOR_WHITE, Constants.COLOR_WHITE, Constants.COLOR_BLACK];
        break;
      case DeviceChangeStatus.LAND_M2G_PORTRAIT:
        startPt = { x: 0, y: -offsetY };
        endPt = { x: 0, y: height + offsetY };
        colors = [Constants.COLOR_BLACK, Constants.COLOR_WHITE, Constants.COLOR_WHITE, Constants.COLOR_WHITE];
        break;
      case DeviceChangeStatus.LAND_INVERTED_M2G_PORTRAIT_INVERTED:
        startPt = { x: 0, y: -offsetY };
        endPt = { x: 0, y: height + offsetY };
        colors = [Constants.COLOR_WHITE, Constants.COLOR_WHITE, Constants.COLOR_WHITE, Constants.COLOR_BLACK];
        break;
      case DeviceChangeStatus.PORTRAIT_F2G_LAND_INVERTED:
        startPt = { x: -offsetX, y: 0 };
        endPt = { x: height + offsetX, y: 0 };
        colors = [Constants.COLOR_WHITE, Constants.COLOR_WHITE, Constants.COLOR_BLACK];
        break;
      default:
        Log.debug(TAG, `other status: ${this.deviceChangeStatus}`);
        break;
    }
    return drawing.ShaderEffect.createLinearGradient(startPt, endPt, colors, drawing.TileMode.CLAMP);
  }

  private createPixelMap(): void {
    if (this.pixelMaps.has(this.imgPath)) {
      this.pixelMap = this.pixelMaps.get(this.imgPath) ?? null;
      return;
    }
    let imageSource: image.ImageSource | undefined = undefined;
    try {
      imageSource = image.createImageSource(this.imgPath);
      this.pixelMap = imageSource.createPixelMapSync();
      this.pixelMaps.set(this.imgPath, this.pixelMap);
    } catch (e) {
      Log.error(TAG, `draw error ${e?.code}, ${e?.message}`);
    } finally {
      if (imageSource) {
        imageSource.release();
      }
    }
  }
}