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
import { effectKit } from '@kit.ArkGraphics2D';
import { BusinessError, systemDateTime } from '@kit.BasicServicesKit';
// import { LogDomain, LogHelper, MemoryUtils } from '@ohos/basicutils';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { LimitMap } from '../../base/utils/LimitMap';
import { LimitSet } from '../../base/utils/LimitSet';
import { ImmInvertColorInfo, InvertColor } from '../bean/ImmInvertColorInfo';
import { IImageSnapshot } from '../../base/interface/IImageSnapshot';

const TAG = 'ImmInvertColorMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// 浅色标识，极浅壁纸
const EXTREMELY_LIGHT_COLOR_PICTURE = 1;
// 浅色标识，浅色壁纸
const LIGHT_COLOR_PICTURE = 2;
// 图片类型，ASTC格式
const PIXEL_FORMAT_ASTC = 102;

// 影响反色开关的参数
class InvertEnableParam {
  // 当前显示沉浸大卡标识
  public curShowingImmHash?: string;

  // 锁屏主页面状态
  public isSlMainPage: boolean = false;

  // 锁屏页面覆盖状态
  public isSlOccluded: boolean = false;

  // 反色开关是否开启
  private _isInvertEnable: boolean = false;

  /**
   * 反色开关
   *
   * @returns true开启反色
   */
  public isInvertEnable(): boolean {
    return this._isInvertEnable;
  }

  /**
   * 刷新反色开关状态
   */
  public updateInvertEnable(): void {
  }
}

// 反色信息切换监听器
export interface OnInvertColorChangeListener {
  /**
   * 反色信息切换回调
   *
   * @param curInvertColor 当前反色信息
   */
  onInvertColorChange: (curInvertColor: ImmInvertColorInfo) => void;
}

/**
 * 沉浸态反色管理器
 */
export class ImmInvertColorMgr {
  // 单例
  private static instance?: ImmInvertColorMgr;

  // 沉浸应用标识-反色信息 映射关系
  private readonly invertColorMap: LimitMap<string, ImmInvertColorInfo> = new LimitMap();

  // 异步反色取值时ID标识
  private readonly asyncIdMap: LimitMap<string, number> = new LimitMap();

  // 反色信息状态切换监听器
  private readonly listeners: LimitSet<OnInvertColorChangeListener> = new LimitSet();

  // 反色开关状态管理
  private readonly invertEnable: InvertEnableParam = new InvertEnableParam();

  // 反色开关
  private isInvertEnable: boolean = this.invertEnable.isInvertEnable();

  // 当前可用反色信息
  private readonly curInvertColor: ImmInvertColorInfo = new ImmInvertColorInfo();

  // ASTC格式图片截图服务能力
  private astcSnapshot?: IImageSnapshot;

  /**
   * 单例
   *
   * @returns 单例
   */
  public static getInstance(): ImmInvertColorMgr {
    if (!ImmInvertColorMgr.instance) {
      ImmInvertColorMgr.instance = new ImmInvertColorMgr();
    }
    return ImmInvertColorMgr.instance;
  }

  private constructor() {
    // 默认无沉浸态状态栏颜色
    this.curInvertColor.setSbContentColor();
  }

  /**
   * 注册反色信息切换监听
   *
   * @param li 监听器
   */
  public registerInvertListener(li: OnInvertColorChangeListener): void {
      return;
  }

  /**
   * 注销反色信息切换监听
   *
   * @param li 监听器
   */
  public unregisterInvertListener(li: OnInvertColorChangeListener): void {
      return;
  }

  /**
   * 设置离屏截图能力
   *
   * @param snapshot 截图服务
   */
  public setAstcSnapshot(snapshot?: IImageSnapshot): void {
      return;
  }

  /**
   * 缓存对应沉浸数据下状态栏背景渐变开关
   *
   * @param hashcode 数据标识
   * @param isSbBgGradientEnable 背景渐变开关
   */
  public cacheSbBgGradientState(hashcode: string | undefined, isSbBgGradientEnable: boolean): void {
    if (!hashcode) {
      return;
    }
    let hasChange = false;
    let info = this.invertColorMap.get(hashcode);
    if (!info) {
      info = new ImmInvertColorInfo();
      this.invertColorMap.set(hashcode, info);
      hasChange = true;
    }
    hasChange = info.setSbBgGradientEnable(isSbBgGradientEnable) || hasChange;
    // 如果为当前沉浸卡片状态变化，则刷新反色信息
    if (hasChange && this.isCurHashcode(hashcode)) {
      this.updateCurInvertColor();
    }
  }

  /**
   * 缓存对应沉浸数据下反色颜色
   *
   * @param hashcode 数据标识
   * @param pic 取反色图片
   * @returns void
   */
  public async cacheInvertColor(hashcode?: string, pic?: image.PixelMap): Promise<void> {
    if (!hashcode || !pic) {
      return;
    }
    let hasChange = false;
    // 缓存前，提前构造反色信息
    if (!this.invertColorMap.has(hashcode)) {
      this.invertColorMap.set(hashcode, new ImmInvertColorInfo());
      hasChange = true;
    }
    // 记录时间戳
    const curTime = this.getCurTime();
    // 异步取出反色颜色
    const color = await this.getInvertColor(pic);
    if (!color) {
      log.showWarn(`cacheInvertColor no color: ${hashcode}`);
      return;
    }
    // 有效时间对比
    if (!this.checkAsyncIdValid(hashcode, curTime)) {
      log.showWarn(`cacheInvertColor invalid id: ${curTime}, ${hashcode}`);
      return;
    }
    // 异步回调后，存在反色信息才进行缓存
    const info = this.invertColorMap.get(hashcode);
    if (info) {
      hasChange = info.setSbContentColor(color) || hasChange;
      hasChange = info.setImmBackBtnColor(color) || hasChange;
    }
    // 如果为当前沉浸卡片状态变化，则刷新反色信息
    if (hasChange && this.isCurHashcode(hashcode)) {
      this.updateCurInvertColor();
    }
  }

  /**
   * 清空对应反色信息
   *
   * @param hashcode 数据标识
   */
  public deleteCacheByHash(hashcode?: string): void {
    if (!hashcode) {
      return;
    }
    // 清除数据为当前显示数据，则刷新反色信息
    if (this.invertColorMap.delete(hashcode) && this.isCurHashcode(hashcode)) {
      this.updateCurInvertColor();
    }
    // 清除异步ID缓存
    this.asyncIdMap.delete(hashcode);
  }

  /**
   * 清空所有缓存反色信息
   */
  public deleteAllCache(): void {
      return;
  }

  /**
   * 设置当前沉浸态显示的应用标识
   *
   * @param hashcode 标识
   */
  public setCurShowingImmersive(hashcode?: string): void {
      return;
  }

  /**
   * 设置锁屏主页面显示状态
   *
   * @param isMainPage true显示主页面
   */
  public setSlMainPageState(isMainPage: boolean): void {
      return;
  }

  /**
   * 设置锁屏覆盖显示状态
   *
   * @param isOccluded true锁屏被覆盖
   */
  public setSlOccluded(isOccluded: boolean): void {
      return;
  }

  private checkInvertEnableChange(): void {
    if (this.isInvertEnable !== this.invertEnable.isInvertEnable()) {
      this.isInvertEnable = this.invertEnable.isInvertEnable();
      // 刷新当前反色信息
      this.updateCurInvertColor();
    }
  }

  private updateCurInvertColor(): void {
    // 默认反色信息
    let sbContentColor: InvertColor | undefined = undefined;
    let isSbBgGradientEnable: boolean = false;
    let immBackBtnColor: InvertColor = InvertColor.COLOR_WHITE;
    // 存在沉浸态标识，并且开启反色则取对应反色信息，否则保持默认
    if (this.isInvertEnable && Boolean(this.invertEnable.curShowingImmHash)) {
      const invertInfo = this.invertColorMap.get(this.invertEnable.curShowingImmHash!);
      sbContentColor = invertInfo?.getSbContentColor();
      isSbBgGradientEnable = invertInfo?.isSbBgGradientEnable() ?? false;
      immBackBtnColor = invertInfo?.getImmBackBtnColor() ?? InvertColor.COLOR_WHITE;
    }
    // 刷新当前反色信息
    let hasChange = this.curInvertColor.setSbContentColor(sbContentColor);
    hasChange = this.curInvertColor.setSbBgGradientEnable(isSbBgGradientEnable) || hasChange;
    hasChange = this.curInvertColor.setImmBackBtnColor(immBackBtnColor) || hasChange;
    if (hasChange) {
      this.notifyInvertColorInfo();
    }
  }

  private notifyInvertColorInfo(): void {
    // 回调反色信息
    this.listeners.forEach((li) => li?.onInvertColorChange(this.curInvertColor));
  }

  private isCurHashcode(hashcode: string): boolean {
    // 当前显示沉浸数据匹配
    return this.invertEnable.curShowingImmHash === hashcode;
  }

  private async getInvertColor(pic: image.PixelMap): Promise<InvertColor | undefined> {
    // 取色区域，顶部高度占比20%
    try {
      const imgInfo = await pic.getImageInfo();
      let resultPic = pic;
      let isReleasePic: boolean = false;
      if (imgInfo.pixelFormat.valueOf() === PIXEL_FORMAT_ASTC) {
        // ASTC类型图片，需要组件上渲染后截图，才能取色
        const snapPic = await this.astcSnapshot?.snapshot(pic);
        if (snapPic) {
          resultPic = snapPic;
          isReleasePic = true;
        }
      }
      const region: number[] = [0, 0, 1.0, 0.1];
      const colorPicker = await effectKit.createColorPicker(resultPic, region);
      const lightDegree = colorPicker?.discriminatePitureLightDegree();
      const isLightPic = lightDegree === EXTREMELY_LIGHT_COLOR_PICTURE || lightDegree === LIGHT_COLOR_PICTURE;
      log.showInfo(`getInvertColor: ${lightDegree}, ${isReleasePic}`);
      // 回收内存
      // MemoryUtils.removeNapiWrap(colorPicker, false);
      // 及时释放截图
      if (isReleasePic) {
        resultPic?.release();
      }
      // 根据图片取反色
      return isLightPic ? InvertColor.COLOR_BLACK : InvertColor.COLOR_WHITE;
    } catch (e) {
      log.showError(`getInvertColor err: ${(e as BusinessError)?.code}`);
      return undefined;
    }
  }

  private checkAsyncIdValid(hashcode: string, asyncId: number): boolean {
    // 异步回调后，比较ID大小
    const oldId = this.asyncIdMap.get(hashcode) ?? 0;
    if (asyncId > oldId) {
      // 记录最新有效ID
      this.asyncIdMap.set(hashcode, asyncId);
      return true;
    }
    return false;
  }

  private getCurTime(): number {
    try {
      return systemDateTime.getTime(true);
    } catch (e) {
      log.showError('getSysTime error.');
      return 0;
    }
  }
}