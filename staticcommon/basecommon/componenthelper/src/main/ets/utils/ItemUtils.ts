/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { UIContext } from '@kit.ArkUI';
import { FrameNode, Position, Size } from '@ohos.arkui.node';
import componentUtils from '@ohos.arkui.componentUtils';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { RectInfo, ThreadUtil, CommonUtils } from '@ohos/basicutils';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { IntelligentCache } from '@ohos/frameworkwrapper';
import { SceneSessionUIContextManager } from './SceneSessionUIContextManager';

const TAG = 'ItemUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const NUMBER_TWO: number = 2;
const PX_SUFFIX: string = 'px';

export class ItemUtils {

  /**
   * get the rectangle with screenID
   *
   * @throws { Error } - empty rectangle error
   *
   * @return return the rectangle
   */
  public static getRectangleByScreenId(key: string, screenId?: number): componentUtils.ComponentInfo {
    let componentInfo: componentUtils.ComponentInfo =
      SCBScreenSessionManager.getInstance().getScreenUIContext(screenId)?.getComponentUtils()?.getRectangleById(key) as componentUtils.ComponentInfo;
    if (CheckEmptyUtils.isEmpty(componentInfo)) {
      log.showError(`empty rectangle with sid-${screenId}`);
      return null;
    }
    return componentInfo;
  }

  /**
   * Get rectangle with screenId and key
   *
   * @param key
   * @param screenId
   * @param context
   * @returns
   */
  public static getCmpRect(key: string, screenId?: number, context?: UIContext): RectInfo {
    let sid = screenId === undefined ? 0 : screenId;
    if (sid === 0) {
      return this.getRectById(key, context);
    }

    const rect: RectInfo = new RectInfo();
    if (key == null) {
      log.showWarn('getCmpRect key is null');
      return rect;
    }

    try {
      let cmpInfo: componentUtils.ComponentInfo = this.getRectangleByScreenId(key, screenId);
      this.convertToRect(rect, cmpInfo, false, context);
      log.showInfo(`getCmpRect ${screenId}-${cmpInfo?.size?.width}-${key}-${JSON.stringify(rect)}`);
      if (IntelligentCache.getInstance().isCardExpandViewId(key)) {
        rect.top = rect.top + IntelligentCache.getInstance().getCardExpandViewOffsetY(key);
        rect.bottom = rect.bottom + IntelligentCache.getInstance().getCardExpandViewOffsetY(key);
      }
    } catch (exception) {
      log.showError(`getCmpRect failed:${exception?.code}, message:${exception?.message}, ${screenId}-key:${key}`);
    }
    return rect;
  }

  /**
   * get the rectangle
   *
   * @throws { Error } - empty rectangle error
   *
   * @return return the rectangle
   */
  public static getRectangleById(key: string): componentUtils.ComponentInfo {
    let componentInfo: componentUtils.ComponentInfo;
    try {
      if (ThreadUtil.isMainThread) {
        componentInfo = sceneSessionManager.getRootSceneUIContext()?.getComponentUtils()?.getRectangleById(key);
      } else {
        componentInfo = componentUtils.getRectangleById(key);
      }
    } catch (err) {
      log.showError(`getRectangleById error, err: ${err}`);
    }
    if (CheckEmptyUtils.isEmpty(componentUtils)) {
      throw new Error('empty rectangle!') as Error;
    }
    return componentInfo;
  }

  /**
   * get the item position
   *
   * @param key the item id
   *
   * @return return the rect info
   */
  public static getRectById(key: string, context?: UIContext): RectInfo {
    const rect: RectInfo = new RectInfo();
    if (key == null) {
      log.showWarn('getRectById key is null');
      return rect;
    }
    try {
      // 该方法拿到的是不带绘制属性的图标位置信息
      let componentInfo: componentUtils.ComponentInfo = this.getRectangleById(key);
      this.convertToRect(rect, componentInfo, false, context);
      log.showInfo(`getRectById screenOffsetX: ${componentInfo.screenOffset.x}, width: ${componentInfo.size.width}, rectLeft: ${rect.left}`);
      if (IntelligentCache.getInstance().isCardExpandViewId(key)) {
        rect.top = rect.top + IntelligentCache.getInstance().getCardExpandViewOffsetY(key);
        rect.bottom = rect.bottom + IntelligentCache.getInstance().getCardExpandViewOffsetY(key);
      }
    } catch (exception) {
      log.showError(`getRectById failed error code:${exception?.code}, message:${exception?.message}, key:${key}`);
    }
    return rect;
  }

  /**
   * 查找当前屏幕显示的组件位置信息
   * @param key 组件id
   * @param context 上下文
   * @returns 位置信息
   */
  public static getRectByIdWithAttachedFrameNode(key: string, context?: UIContext) : RectInfo {
    const rect: RectInfo = new RectInfo();
    if (CheckEmptyUtils.checkStrIsEmpty(key)) {
      log.showWarn('getRectByIdWithAttachedFrameNode key is null');
      return rect;
    }
    try {
      // 主线程走当前屏查找逻辑，非主线程走原逻辑
      if (ThreadUtil.isMainThread) {
        let frameNode : FrameNode = sceneSessionManager.getRootSceneUIContext()?.getAttachedFrameNodeById(key);
        let position : Position = frameNode?.getPositionToWindow();
        let size: Size = frameNode?.getMeasuredSize();
        if (CommonUtils.isInvalid(position) || CommonUtils.isInvalid(size)) {
          return rect;
        }
        log.showInfo(`getRectByIdWithAttachedFrameNode position: [${position?.x}-${position?.y}],` +
          ` size: [${size?.height}-${size?.height}] Unique:${frameNode?.getUniqueId()}`);
        this.covertToRectFrame(rect, size, position, context);
      } else {
        let componentInfo: componentUtils.ComponentInfo = componentUtils.getRectangleById(key);
        log.showInfo(`getRectByIdWithAttachedFrameNode screenOffsetX: ${componentInfo.screenOffset.x}, width: ${componentInfo.size.width}, rectLeft: ${rect.left}`);
        this.convertToRect(rect, componentInfo, false, context);
      }
      if (IntelligentCache.getInstance().isCardExpandViewId(key)) {
        rect.top = rect.top + IntelligentCache.getInstance().getCardExpandViewOffsetY(key);
        rect.bottom = rect.bottom + IntelligentCache.getInstance().getCardExpandViewOffsetY(key);
      }
    } catch (exception) {
      log.showError(`getRectByIdWithAttachedFrameNode failed error code:${exception?.code}, message:${exception?.message}, key:${key}`);
      return ItemUtils.getRectById(key, context);
    }
    return rect;
  }

  /**
   * 将获取的position和size转换成启动退出所需要的坐标信息
   * @param rect 待修改的坐标信息变量
   * @param size 大小信息
   * @param position 位置信息
   * @param context 上下文
   */
  private static covertToRectFrame(rect: RectInfo, size: Size, position : Position,
     context?: UIContext) : void {
    let convertPixel2Vp: (value: number) => number = context ? (value: number): number => context.px2vp(value) : px2vp;
    rect.left = position.x;
    rect.top = position.y;
    rect.height = convertPixel2Vp(size.height);
    rect.width = convertPixel2Vp(size.width);
    rect.right = position.x + rect.width;
    rect.bottom = position.y + rect.height;
  }

  /**
   * 获取FrameNode相对于屏幕带有绘制属性的坐标信息，单位为vp
   * @param id 组件id
   * @param context 扩展屏上下文信息
   * @throws { Error } - empty pos error
   * @returns 坐标信息
   */
  public static getFrameNodePosById(id: string): Position {
    let pos: Position =
      SceneSessionUIContextManager.getInstance().
      getUiContext().getFrameNodeById(id)?.getPositionToScreenWithTransform() as Position;
    return pos;
  }

  /**
   * 获取frameNode相对于屏幕带有绘制属性的大小信息，单位为vp
   * @param id 组件id
   * @param context 扩展屏上下文信息
   * @throws { Error } - empty size error
   * @returns 大小信息
   */
  public static getFrameNodeSizeById(id: string): Size {
    let size: Size =
      SceneSessionUIContextManager.getInstance().
      getUiContext().getFrameNodeById(id)?.getMeasuredSize() as Size;
    return size;
  }

  /**
   * 获取frameNode相对于屏幕带有绘制属性的位置大小信息，单位为vp
   * @param id 组件id
   * @param context 扩展屏上下文信息
   * @returns 组件位置和大小信息
   */
  public static getFrameNodeRectById(id: string): RectInfo {
    const rect: RectInfo = new RectInfo();
    if (id === null || id === undefined) {
      log.showWarn('getRectById key is null');
      return rect;
    }
    try {
      let pos: Position = this.getFrameNodePosById(id);
      let size: Size = this.getFrameNodeSizeById(id);
      this.convertFrameNodeInfoToRect(rect, pos, size);
    } catch (exception) {
      log.showError(`getFrameNodeRectById failed error code:${exception?.code}, message:${exception?.message}, id:${id}`);
    }
    return rect;
  }

  public static getScaleById(key: string): componentUtils.ScaleResult {
    try {
      let componentInfo: componentUtils.ComponentInfo = this.getRectangleById(key);
      return componentInfo.scale;
    } catch (exception) {
      log.showError(`getScaleById failed: ${JSON.stringify(exception)}, key:${key}`);
      return null;
    }
  }

  public static getOffsetRelativeScreenById(key: string): componentUtils.Offset {
    try {
      let componentInfo: componentUtils.ComponentInfo = this.getRectangleById(key);
      return componentInfo.screenOffset;
    } catch (exception) {
      log.showError(`getOffsetRelativeScreenById failed error code:${exception?.code}, message:${exception?.message}, key:${key}`);
      return null;
    }
  }

  public static getRectByIdWithTransform(key: string): RectInfo {
    const rect: RectInfo = new RectInfo();
    try {
      let componentInfo: componentUtils.ComponentInfo = this.getRectangleById(key);
      this.convertToRect(rect, componentInfo, true);
    } catch (exception) {
      log.showError(`getRectByIdWithTransform failed error code:${exception?.code}, message:${exception?.message}, key:${key}`);
    }
    return rect;
  }

  private static convertToRect(rect: RectInfo, componentInfo: componentUtils.ComponentInfo,
    isNeedTransform: boolean, context?: UIContext): void {
    let convertPixel2Vp: (value: number) => number = context ? (value: number): number => context.px2vp(value) : px2vp;
    if (isNeedTransform) {
      const widthScaleGap = componentInfo.size.width * ( componentInfo.scale.x - 1) / NUMBER_TWO;
      const heightScaleGap = componentInfo.size.height * ( componentInfo.scale.y - 1) / NUMBER_TWO;
      rect.left = convertPixel2Vp(componentInfo.screenOffset.x - widthScaleGap) + componentInfo.translate.x;
      rect.top = convertPixel2Vp(componentInfo.screenOffset.y - heightScaleGap) + componentInfo.translate.y;
      rect.right = convertPixel2Vp(componentInfo.screenOffset.x + componentInfo.size.width + widthScaleGap) +
        componentInfo.translate.x;
      rect.bottom = convertPixel2Vp(componentInfo.screenOffset.y + componentInfo.size.height + heightScaleGap) +
        componentInfo.translate.y;
      rect.height = componentInfo.size.height * componentInfo.scale.y;
      rect.width = componentInfo.size.width * componentInfo.scale.x;
    } else {
      rect.left = convertPixel2Vp(componentInfo.screenOffset.x);
      rect.top = convertPixel2Vp(componentInfo.screenOffset.y);
      rect.right = convertPixel2Vp(componentInfo.screenOffset.x + componentInfo.size.width);
      rect.bottom = convertPixel2Vp(componentInfo.screenOffset.y + componentInfo.size.height);
      rect.height = convertPixel2Vp(componentInfo.size.height);
      rect.width = convertPixel2Vp(componentInfo.size.width);
    }
  }

  private static convertFrameNodeInfoToRect(rect: RectInfo, frameNodePos: Position, frameNodeSize: Size): void {
    rect.left = frameNodePos.x;
    rect.top = frameNodePos.y;
    rect.right = rect.left + px2vp(frameNodeSize.width);
    rect.bottom = rect.top + px2vp(frameNodeSize.height);
    rect.height = px2vp(frameNodeSize.height);
    rect.width = px2vp(frameNodeSize.width);
  }

  public static num2PxStr(value: number): string {
    return value + PX_SUFFIX;
  }

  public static vp2PxStr(value: number): string {
    return vp2px(value) + PX_SUFFIX;
  }
}