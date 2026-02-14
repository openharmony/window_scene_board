/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import { GlobalContext } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import type ctx from '@ohos.app.ability.common';
import { DragConstants } from '@ohos/commonconstants';
import type { DragEventCallback, SqueezeExtraParam } from '../service/drag/DragEventCallback';
import type image from '@ohos.multimedia.image';

const TAG = 'DragEventManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 拖拽事件管理类,负责功能：
 * 1.落位动效控件在拖拽过程中的上树下树和动效显示
 * 2.被拖拽控件的显示隐藏
 * 3.待添加...
 */
export class DragEventManager {
  private _isDropInDesktop: boolean = false;

  private _isOuterDesktop: boolean = false;

  public setIsOuterDesktop(value: boolean): void {
    this._isOuterDesktop = value;
  }

  public get isDropInDesktop(): boolean {
    return this._isDropInDesktop;
  }

  private dragPixelMap: image.PixelMap | undefined | string = undefined;

  /**
   * 获取拖拽元素截图
   *
   * @returns 截图
   */
  public getPixelMap(): image.PixelMap | undefined | string {
    return this.dragPixelMap;
  }

  /**
   * 设置拖拽元素截图
   *
   * @returns
   */
  public setPixelMap(image: image.PixelMap | undefined | string): void {
    this.dragPixelMap = image;
  }

  static getInstance(isOuter: boolean = false): DragEventManager {
      if (globalThis.DragEventManager == null) {
        globalThis.DragEventManager = new DragEventManager();
      }
      return globalThis.DragEventManager;
  }

  private getContext(): ctx.ServiceExtensionContext {
    return GlobalContext.getContext();
  }

  /**
   * 获取桌面上元素起拖的事件
   *
   * @param itemKey 拖拽元素的标识
   * @returns 桌面上元素起拖的事件
   */
  private getDragStartInDesktopEvent(itemKey: string): string {
    // 事件命名规则为事件头加对应组件的id加当前所处页数
    return this._isOuterDesktop ? `${DragConstants.DRAG_START_EVENT}${itemKey}_OuterDesktop` :
      `${DragConstants.DRAG_START_EVENT}${itemKey}`;
  }

  /**
   * 获取当前拖拽元素开始落位事件
   *
   * @param itemKey 当前拖拽元素的标识
   * @returns 当前拖拽元素开始落位事件
   */
  private getDropStartEvent(itemKey: string): string {
    // 事件命名规则为事件头加对应元素的标识
    return this._isOuterDesktop ? `${DragConstants.DROP_START_EVENT}${itemKey}_OuterDesktop` :
      `${DragConstants.DROP_START_EVENT}${itemKey}`;
  }

  /**
   * 获取当前拖拽元素落位动效结束事件
   *
   * @param itemKey 当前拖拽元素的标识
   * @returns 当前拖拽元素落位动效结束事件
   */
  private getDropAnimationEndEvent(itemKey: string): string {
    // 事件命名规则为事件头加对应元素的标识
    return this._isOuterDesktop ? `${DragConstants.DROP_ANIMATION_END_EVENT}${itemKey}_OuterDesktop` :
      `${DragConstants.DROP_ANIMATION_END_EVENT}${itemKey}`;
  }

  /**
   * 获取当前拖拽元素开始挤位事件
   *
   * @param itemKey 当前拖拽元素的标识
   * @returns 当前拖拽元素开始挤位事件
   */
  private getItemSqueezedStartEvent(itemKey: string): string {
    return this._isOuterDesktop ? `${DragConstants.ITEM_SQUEEZED_START_EVENT}${itemKey}_OuterDesktop` :
      `${DragConstants.ITEM_SQUEEZED_START_EVENT}${itemKey}`;
  }

  /**
   * 获取当前拖拽元素取消挤位事件
   *
   * @param itemKey 当前拖拽元素的标识
   * @returns 当前拖拽元素取消挤位事件
   */
  private getItemSqueezedCancelEvent(itemKey: string): string {
    return this._isOuterDesktop ? `${DragConstants.ITEM_SQUEEZED_CANCEL_EVENT}${itemKey}_OuterDesktop` :
      `${DragConstants.ITEM_SQUEEZED_CANCEL_EVENT}${itemKey}`;
  }

  /**
   * 元素在桌面上起拖的事件处理，与文件夹中处理不同，待以后统一收编
   *
   * @param itemKey 对应的组件标识
   */
  public dragStartInDesktop(itemKey: string): void {
    log.showInfo('drag start in desktop, itemKey: %{public}s', itemKey);
    this._isDropInDesktop = false;
    this.getContext()?.eventHub.emit(this.getDragStartInDesktopEvent(itemKey));
  }

  /**
   * 桌面元素被挤位的事件处理
   *
   * @param itemKey 被挤位元素标识
   * @param translatePosition 挤位的起点和终点
   * @param squeezeExtraParam 挤位动效的额外效果参数（可选）
   */
  public startSqueezedInDesktop(itemKey: string, translatePosition: number[][],
    squeezeExtraParam?: SqueezeExtraParam): void {
    log.showInfo('startSqueezedInDesktop itemKey:%{public}s', itemKey);
    this.getContext()?.eventHub.emit(this.getItemSqueezedStartEvent(itemKey), translatePosition, squeezeExtraParam);
  }

  /**
   * 桌面元素取消挤位的事件处理
   *
   * @param itemKey 被挤位元素标识
   * @param hasAnimation 取消挤位时是否有动效，默认有动效
   */
  public cancelSqueezedInDesktop(itemKey: string, hasAnimation: boolean = true): void {
    log.showInfo('cancelSqueezedInDesktop itemKey:%{public}s hasAnimation:%{public}s', itemKey, hasAnimation);
    this.getContext()?.eventHub.emit(this.getItemSqueezedCancelEvent(itemKey), hasAnimation);
  }

  /**
   * 落位准备工作结束后开始落位流程
   *
   * @param itemKey 拖拽元素标识符
   */
  public startDrop(itemKey: string): void {
    log.showInfo('startDrop itemKey:%{public}s', itemKey);
    this._isDropInDesktop = true;
    this.getContext()?.eventHub.emit(this.getDropStartEvent(itemKey));
  }

  /**
   * 落位完成
   *
   * @param itemKey 拖拽元素标识符
   */
  public dropEnd(itemKey: string): void {
    log.showInfo('dropEnd itemKey:%{public}s', itemKey);
    this.getContext()?.eventHub.emit(this.getDropAnimationEndEvent(itemKey));
  }

  /**
   * 注册桌面元素的相关拖拽事件
   *
   * @param eventCallback 相关拖拽事件的回调集合
   * @param itemKey 桌面元素标识
   */
  public registerDragEvent(eventCallback: DragEventCallback, itemKey: string): void {
    if (!eventCallback || !itemKey) {
      log.showError('registerDragEvent error, itemKey:%{public}s', `${itemKey}`);
      return;
    }
    this.registerEvent(this.getDragStartInDesktopEvent(itemKey), eventCallback.onItemDragStartEvent);
    this.registerEvent(this.getItemSqueezedStartEvent(itemKey), eventCallback.onStartSqueezedEvent);
    this.registerEvent(this.getItemSqueezedCancelEvent(itemKey), eventCallback.onCancelSqueezedEvent);
    this.registerEvent(this.getDropStartEvent(itemKey), eventCallback.onItemDropStartEvent);
    this.registerEvent(this.getDropAnimationEndEvent(itemKey), eventCallback.onItemDropEndEvent);
    log.showInfo(`register drag event ${itemKey} success`);
  }

  /**
   * 解除桌面元素的相关拖拽事件注册
   *
   * @param eventCallback 相关拖拽事件的回调集合
   * @param itemKey 桌面元素标识
   */
  public unRegisterDragEvent(eventCallback: DragEventCallback, itemKey: string): void {
    if (!eventCallback || !itemKey) {
      log.showError('unRegisterDragEvent error, itemKey:%{public}s', `${itemKey}`);
      return;
    }
    this.unRegisterEvent(this.getDragStartInDesktopEvent(itemKey), eventCallback.onItemDragStartEvent);
    this.unRegisterEvent(this.getItemSqueezedStartEvent(itemKey), eventCallback.onStartSqueezedEvent);
    this.unRegisterEvent(this.getItemSqueezedCancelEvent(itemKey), eventCallback.onCancelSqueezedEvent);
    this.unRegisterEvent(this.getDropStartEvent(itemKey), eventCallback.onItemDropStartEvent);
    this.unRegisterEvent(this.getDropAnimationEndEvent(itemKey), eventCallback.onItemDropEndEvent);
    log.showInfo(`unregister drag event ${itemKey} success`);
  }

  private registerEvent(event: string, callback: Function): void {
    if (!callback) {
      log.showError('registerEvent callback is null, event:%{public}s', event);
      return;
    }
    this.getContext()?.eventHub.on(event, callback);
  }

  private unRegisterEvent(event: string, callback: Function): void {
    if (!callback) {
      log.showError('unRegisterEvent callback is null, event:%{public}s', event);
      return;
    }
    this.getContext()?.eventHub.off(event, callback);
  }
}