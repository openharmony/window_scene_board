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

import image from '@ohos.multimedia.image';
import { LogDomain, LogHelper, PixelMapUtil } from '@ohos/basicutils';
import componentSnapshot from '@ohos.arkui.componentSnapshot';
import { SingletonHelper } from '@ohos/basicutils';
import { Callback } from '@ohos.base';
import fs from '@ohos.file.fs';
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { CustomBuilder } from 'DragControllerParam';
import { GlobalContext } from '@ohos/frameworkwrapper';

const TAG: string = 'DragSnapshotHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 截图的类型
 */
export const enum SnapshotType {
  /**
   * 用于拖拽显示的截图
   */
  DRAG = 0,

  /**
   * 用于落位动效显示的截图
   */
  DROP = 1,

  /**
   * 既用于拖拽显示，也用于落位动效显示的截图
   */
  BOTH = 2,
}

/**
 * 截图完成的监听器
 */
export interface SnapshotListener {
  /**
   * 截图完成触发的回调
   *
   * @param image 截图对象
   * @param type 截图的类型
   * @param key 截图的标识符
   */
  onSnapshotFinish?: (image: image.PixelMap, type: SnapshotType, key: string) => void;

  /**
   * 截图释放的回调
   *
   * @param type 截图的类型
   * @param key 截图的标识符
   */
  onSnapshotRelease?: (type: SnapshotType, key: string) => void;
}

export interface extendSnapshotParam {
  scaleX ?: number,
  scaleY ?: number,
  name ?: string
}

/**
 * 拖拽相关截图辅助类，保存两张截图，分别用于拖拽显示和落位动效显示
 */
class DragSnapshotHelper {
  static readonly SNAPSHOT_TYPES: SnapshotType[] = [SnapshotType.DRAG, SnapshotType.DROP, SnapshotType.BOTH];

  private dragSnapshot?: image.PixelMap;
  private dropSnapshot?: image.PixelMap;
  private itemKey: string = '';
  private snapshotListeners: Map<string, Set<SnapshotListener>> = new Map();
  private isEnableWriteSnapshot: number = 0;

  constructor() {
    this.registerDebug();
  }

  private registerDebug(): void {
    let cmds: DebugCommand[] = [];
    cmds.push({
      cmdName: 'SetEnableWrite',
      callback: (args: string[]) => {
        let res: boolean = this.setEnableWrite(args);
        return 'Set EnableWrite as ' + args?.[0] + ' ' + res ? 'success' : 'failed';
      }
    });
    DebugCommandManager.getInstance().register(TAG, cmds);
  }

  /**
   * 设置是否能够将截图持久化
   *
   * @param args 参数
   * @returns 是否设置成功
   */
  public setEnableWrite(args: string[]): boolean {
    if (!args || args.length === 0) {
      return false;
    }

    let value = Number(args[0]);
    if (isNaN(value)) {
      return false;
    }

    this.isEnableWriteSnapshot = value;
    return true;
  }

  /**
   * 是否能够将截图持久化
   *
   * @returns 是否能够将截图持久化
   */
  public isEnableWrite(): boolean {
    return this.isEnableWriteSnapshot > 0;
  }

  /**
   * 注册截图完成的监听器
   *
   * @param listener 截图完成的监听器
   * @param key 截图的标识符
   */
  public registerSnapshotListener(listener: SnapshotListener, key: string): void {
    if (this.snapshotListeners.has(key)) {
      this.snapshotListeners.get(key).add(listener);
    } else {
      let set: Set<SnapshotListener> = new Set();
      set.add(listener);
      this.snapshotListeners.set(key, set);
    }
  }

  /**
   * 解注册截图完成的监听器
   *
   * @param listener 截图完成的监听器
   * @param key 截图的标识符
   */
  public unregisterSnapshotListener(listener: SnapshotListener, key: string): void {
    if (!this.snapshotListeners.has(key)) {
      return;
    }
    let set = this.snapshotListeners.get(key);
    set.delete(listener);
    if (set.size === 0) {
      this.snapshotListeners.delete(key);
    }
  }

  /**
   * 清空截图监听器，若key为空则清空所有监听器，若key不为空则清空key对应的监听器
   *
   * @param key 截图的标识符
   */
  public clearListener(key?: string): void {
    if (key == null) {
      this.snapshotListeners.clear();
    } else {
      this.snapshotListeners.delete(key);
    }
  }

  /**
   * 获取截图监听器的数量
   *
   * @param key 截图的标识符
   * @returns 截图监听器的数量
   */
  public getListenerCount(key: string): number {
    return this.snapshotListeners.get(key)?.size ?? 0;
  }

  private triggerSnapshotFinish(value: image.PixelMap, type: SnapshotType, key: string): void {
    this.snapshotListeners.get(key)?.forEach((listener) => listener.onSnapshotFinish?.(value, type, key));
  }

  private triggerSnapshotRelease(type: SnapshotType, key: string): void {
    this.snapshotListeners.get(key)?.forEach((listener) => listener.onSnapshotRelease?.(type, key));
  }

  /**
   * 获取保存的截图
   *
   * @param type 截图的类型
   * @param itemKey 截图的标识符
   * @returns 对应的截图
   */
  public getSnapshot(type: SnapshotType, itemKey?: string): image.PixelMap | undefined {
    let snapshot: image.PixelMap | undefined = undefined;
    if (!CheckEmptyUtils.isEmpty(itemKey) && itemKey === this.itemKey) {
      switch (type) {
        case SnapshotType.DRAG:
          snapshot = this.dragSnapshot;
          break;
        case SnapshotType.DROP:
          snapshot = this.dropSnapshot;
          break;
        default:
          break;
      }
    }
    log.showInfo('getSnapshot type:%{public}d itemKey:%{public}s snapshot:%{public}s', type, String(itemKey),
      String(snapshot?.getPixelBytesNumber()));
    return snapshot;
  }

  /**
   * 设置截图
   *
   * @param value 需要保存的截图
   * @param type 截图的类型
   * @param itemKey 截图的标识符
   */
  public setSnapshot(value: image.PixelMap, type: SnapshotType, itemKey: string, isAddName: boolean = false): void {
    switch (type) {
      case SnapshotType.DRAG:
        this.setDragSnapshot(value);
        if (isAddName) {
          PixelMapUtil.addName(value, `dag:${itemKey}`);
          log.showInfo(`set dag:${itemKey}`);
        }
        if (this.itemKey !== itemKey) {
          this.releaseDrop();
        }
        break;
      case SnapshotType.DROP:
        this.setDropSnapshot(value);
        if (isAddName) {
          PixelMapUtil.addName(value, `dop:${itemKey}`);
          log.showInfo(`set dop:${itemKey}`);
        }
        if (this.itemKey !== itemKey) {
          this.releaseDrag();
        }
        break;
      case SnapshotType.BOTH:
        this.setDragSnapshot(value);
        this.setDropSnapshot(value);
        if (isAddName) {
          PixelMapUtil.addName(value, `bth:${itemKey}`);
          log.showInfo(`set bth:${itemKey}`);
        }
        break;
      default:
        break;
    }
    this.itemKey = itemKey;
  }

  /**
   * 释放保存的截图
   *
   * @param type 截图的类型
   * @param itemKey 截图的标识符
   */
  public releaseSnapshot(type: SnapshotType, itemKey: string): void {
    if (itemKey !== this.itemKey) {
      return;
    }
    log.showInfo('releaseSnapshot type:%{public}d itemKey:%{public}s', type, itemKey);
    switch (type) {
      case SnapshotType.DRAG:
        this.releaseDrag();
        return;
      case SnapshotType.DROP:
        this.releaseDrop();
        return;
      case SnapshotType.BOTH:
        this.releaseDrag();
        this.releaseDrop();
        return;
      default:
        return;
    }
  }

  private releaseDrag(): void {
    if (this.dragSnapshot) {
      this.dragSnapshot.release()
        .then(() => {
          log.showInfo(`release old drag ${this.itemKey}`);
        })
        .catch((error: string) => {
          log.showInfo(`release old drag ${this.itemKey} error:${error}`);
        });
      this.dragSnapshot = undefined;
      this.triggerSnapshotRelease(SnapshotType.DRAG, this.itemKey);
    }
  }

  private releaseDrop(): void {
    if (this.dropSnapshot) {
      this.dropSnapshot.release()
        .then(() => {
          log.showInfo(`release old drop ${this.itemKey}`);
        })
        .catch((error: string) => {
          log.showInfo(`release old drop ${this.itemKey} error:${error}`);
        });
      this.dropSnapshot = undefined;
      this.triggerSnapshotRelease(SnapshotType.DROP, this.itemKey);
    }
  }

  private setDragSnapshot(value: image.PixelMap): void {
    this.releaseDrag();
    this.dragSnapshot = value;
  }

  private setDropSnapshot(value: image.PixelMap): void {
    this.releaseDrop();
    this.dropSnapshot = value;
  }

  /**
   * 使用id进行截图, 异步操作
   *
   * @param id 组件的id
   * @param type 截图的类型
   * @param itemKey 截图元素的标识
   * @param callback 截图结束的回调
   */
  public snapshotFromId(id: string, type: SnapshotType, itemKey?: string,
    callback?: Callback<image.PixelMap>, scaleX?: number, scaleY?: number, name?: string): void {
    this.snapshot(() => componentSnapshot.get(id), type, itemKey, callback, scaleX, scaleY, name);
  }

  /**
   * 使用id进行截图, 同步等待
   *
   * @param id 组件的id
   * @param type 截图的类型
   * @param itemKey 截图元素的标识
   * @param callback 截图结束的回调
   */
  public snapshotFromIdSync(id: string, type: SnapshotType, itemKey?: string,
    callback?: Callback<image.PixelMap>, scaleX?: number, scaleY?: number, name?: string): void {
    this.snapshotSync(() => componentSnapshot.getSync(id), type, itemKey, callback, scaleX, scaleY, name);
  }

  public snapshotFromIdAsync(
    id: string, type: SnapshotType, itemKey?: string, extendSnapshotParam?: extendSnapshotParam
  ): Promise<image.PixelMap> {
    return this.snapshotAsync(() => componentSnapshot.get(id), type, itemKey, extendSnapshotParam);
  }

  /**
   * 在主线程 UI 操作结束后，使用id进行截图
   *
   * @param id 组件的id
   * @param type 截图的类型
   * @param itemKey 截图元素的标识
   * @param callback 截图结束的回调
   */
  public snapshotUntilRenderFinishedFromId(id: string, type: SnapshotType, itemKey?: string,
    callback?: Callback<image.PixelMap>, scaleX?: number, scaleY?: number): void {
    this.snapshot(() => componentSnapshot.get(
      id, {waitUntilRenderFinished: true}), type, itemKey, callback, scaleX, scaleY);
  }

  /**
   * 使用builder进行截图
   *
   * @param builder 截图使用的builder
   * @param type 截图的类型
   * @param itemKey 截图元素的标识
   * @param callback 截图结束的回调
   */
  public snapshotFromBuilder(builder: CustomBuilder, type: SnapshotType, itemKey?: string,
    callback?: Callback<image.PixelMap>, scaleX?: number, scaleY?: number, name?: string, delayTime?: number): void {
    if (delayTime != null) {
      this.snapshot(
        () => componentSnapshot.createFromBuilder(builder, delayTime),
        type,
        itemKey,
        callback,
        scaleX,
        scaleY,
        name
      );
    } else {
      this.snapshot(() => componentSnapshot.createFromBuilder(builder), type, itemKey, callback, scaleX, scaleY, name);
    }
  }

  public snapshotFromBuilderAsync(
    builder: CustomBuilder,
    type: SnapshotType,
    itemKey?: string,
    extendSnapshotParam?: extendSnapshotParam
  ): Promise<image.PixelMap> {
    return new Promise<image.PixelMap>((resolve, reject) => {
      const snapshot =
        this.snapshotAsync(() => componentSnapshot.createFromBuilder(builder), type, itemKey, extendSnapshotParam);
      if (snapshot) {
        resolve(snapshot);
      } else {
        reject();
      }
    });
  }

  public async snapshotAsync(
    snapshotFunc: () => Promise<image.PixelMap>,
    type: SnapshotType,
    itemKey?: string,
    extendSnapshotParam?: extendSnapshotParam
  ): Promise<image.PixelMap | undefined> {
    log.showInfo('snapshot type:%{public}d itemKey:%{public}s', type, String(itemKey));
    if (CheckEmptyUtils.isEmpty(itemKey) || DragSnapshotHelper.SNAPSHOT_TYPES.indexOf(type) < 0) {
      return undefined;
    }
    if (AppStorage.get<boolean>('isDrag')) {
      log.showWarn('cannot update drag snapshot during dragging');
      return undefined;
    }
    try {
      return this.processSnapshotAsync(snapshotFunc(), type, String(itemKey), extendSnapshotParam);
    } catch (error) {
      log.error('snapshotForDrop catch error', error);
    }
    return undefined;
  }

  /**
   * 处理截图
   *
   * @param snapshotFunc 获取截图的方法，返回image.PixelMap类型的图片对象
   * @param type 截图的类型
   * @param itemKey 截图元素的标识符
   * @param callback 截图结束的回调
   */
  public snapshot(snapshotFunc: () => Promise<image.PixelMap>, type: SnapshotType, itemKey?: string,
    callback?: Callback<image.PixelMap>, scaleX?: number, scaleY?: number, name?: string): boolean {
    log.showInfo('snapshot type:%{public}d itemKey:%{public}s', type, String(itemKey));
    if (CheckEmptyUtils.isEmpty(itemKey) || DragSnapshotHelper.SNAPSHOT_TYPES.indexOf(type) < 0) {
      return false;
    }
    if (AppStorage.get<boolean>('isDrag')) {
      log.showWarn('cannot update drag snapshot during dragging');
      return false;
    }
    try {
      this.processSnapshot(snapshotFunc(), type, String(itemKey), callback, scaleX, scaleY, name);
      return true;
    } catch (error) {
      log.error('snapshotForDrop catch error', error);
    }
    return false;
  }

  /**
   * 同步处理截图
   *
   * @param snapshotFunc 获取截图的方法，返回image.PixelMap类型的图片对象
   * @param type 截图的类型
   * @param itemKey 截图元素的标识符
   * @param callback 截图结束的回调
   */
  public snapshotSync(snapshotFunc: () => image.PixelMap, type: SnapshotType, itemKey?: string,
    callback?: Callback<image.PixelMap>, scaleX?: number, scaleY?: number, name?: string): boolean {
    log.showInfo('snapshot type:%{public}d itemKey:%{public}s', type, String(itemKey));
    if (CheckEmptyUtils.isEmpty(itemKey) || DragSnapshotHelper.SNAPSHOT_TYPES.indexOf(type) < 0) {
      return false;
    }
    if (AppStorage.get<boolean>('isDrag')) {
      log.showWarn('cannot update drag snapshot during dragging');
      return false;
    }
    try {
      this.processSnapshotSync(snapshotFunc(), type, String(itemKey), callback, scaleX, scaleY, name);
      return true;
    } catch (error) {
      log.error('snapshotForDrop catch error', error);
    }
    return false;
  }

  private processSnapshot(snapshot: Promise<image.PixelMap>, type: SnapshotType, itemKey: string,
    callback?: Callback<image.PixelMap>, scaleX?: number, scaleY?: number, name?: string): void {
    snapshot.then(async (value: image.PixelMap) => {
      if (!isNaN(scaleX) && !isNaN(scaleY) && (scaleX !== 1 || scaleY !== 1)) {
        log.showInfo('processSnapshot scaleX:%{public}d,scaleY:%{public}d', scaleX, scaleY);
        await value.scale(scaleX, scaleY);
      }
      log.showInfo('get snapshot success. type:%{public}d itemKey:%{public}s', type, itemKey);
      const isAddName = (value && name) ? true : false;
      if (isAddName) {
        PixelMapUtil.addName(value, name);
      }
      this.printImageInfo(value);
      this.setSnapshot(value, type, itemKey, !isAddName);
      this.triggerSnapshotFinish(value, type, itemKey);
      callback?.(value);
      this.writeSnapshot(value, itemKey);
    }).catch((error: Error) => {
      log.error('snapshot catch error', error);
    });
  }

  private processSnapshotSync(snapshot: image.PixelMap, type: SnapshotType, itemKey: string,
    callback?: Callback<image.PixelMap>, scaleX?: number, scaleY?: number, name?: string): void {
    let value = snapshot;
    if (!isNaN(scaleX) && !isNaN(scaleY) && (scaleX !== 1 || scaleY !== 1)) {
      log.showInfo('processSnapshot scaleX:%{public}d,scaleY:%{public}d', scaleX, scaleY);
      value.scale(scaleX, scaleY);
    }
    log.showInfo('get snapshot success. type:%{public}d itemKey:%{public}s', type, itemKey);
    const isAddName = (value && name) ? true : false;
    if (isAddName) {
      PixelMapUtil.addName(value, name);
    }
    this.printImageInfo(value);
    this.setSnapshot(value, type, itemKey, !isAddName);
    this.triggerSnapshotFinish(value, type, itemKey);
    callback?.(value);
    this.writeSnapshot(value, itemKey);
  }

  private async processSnapshotAsync(
    snapshot: Promise<image.PixelMap>, type: SnapshotType, itemKey: string, extendParam?: extendSnapshotParam
  ): Promise<image.PixelMap | undefined> {
    try {
      const snapshotRes = await snapshot;
      if (extendParam &&
        !isNaN(extendParam.scaleX) &&
        !isNaN(extendParam.scaleY) &&
        (extendParam.scaleX !== 1 || extendParam.scaleY !== 1)
      ) {
        log.showInfo('processSnapshot scaleX:%{public}d,scaleY:%{public}d', extendParam.scaleX, extendParam.scaleY);
        await snapshotRes.scale(extendParam.scaleX, extendParam.scaleY);
      }
      log.showInfo('get snapshot success. type:%{public}d itemKey:%{public}s', type, itemKey);
      const isAddName = (snapshotRes && extendParam && extendParam.name) ? true : false;
      if (isAddName) {
        PixelMapUtil.addName(snapshotRes, extendParam.name);
      }
      this.printImageInfo(snapshotRes);
      this.setSnapshot(snapshotRes, type, itemKey, !isAddName);
      this.triggerSnapshotFinish(snapshotRes, type, itemKey);
      Promise.resolve().then(() => {
        this.writeSnapshot(snapshotRes, itemKey);
      });
      return snapshotRes;
    } catch (error) {
      log.error('snapshot catch error', error);
    };
    return undefined;
  }

  private printImageInfo(image: image.PixelMap): void {
    image.getImageInfo().then((imageInfo: image.ImageInfo) => {
      log.showInfo('get snapshot imageInfo success. width:%{public}d height:%{public}d', imageInfo.size.width,
        imageInfo.size.height);
    }).catch((error: Error) => {
      log.error('get imageInfo error', error);
    });
  }

  private writeSnapshot(pixmap: image.PixelMap, itemKey: string): void {
    if (!this.isEnableWrite()) {
      return;
    }
    let snapshot = `${GlobalContext.getContext().cacheDir}/${itemKey}_snapshot.png`;
    log.showInfo(`writeSnapshot snapshot = ${snapshot}`);
    let file = fs.openSync(snapshot, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    const imagePackerApi = image.createImagePacker();
    let packOpts = { format: 'image/png', quality: 100 };
    imagePackerApi.packing(pixmap, packOpts).then((data) => {
      let writeLen = fs.writeSync(file.fd, data);
      log.showInfo(`writeSnapshot success length = ${writeLen}`);
    }).catch((err: Error) => {
      log.error('writeSnapshot error ', err);
    }).finally(() => {
      fs.closeSync(file);
      imagePackerApi?.release();
    });
  }

  /**
   * 对外提供拖拽元素标识符接口
   * @returns 截图元素的标识符
   */
  public getDragItemKey(): string {
    return this.itemKey;
  }
}

export const dragSnapshotHelper: DragSnapshotHelper = SingletonHelper.getInstance(DragSnapshotHelper, TAG);