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

// TODO SCB
import type { ViewArea as ScreenRect } from '@ohos/frameworkwrapper';
import type screenSessionManager from '@ohos.screenSessionManager';
import type { SCBScreenSession } from '../screen/session/SCBScreenSession';
import { CutoutEvent, WaterfallEvent } from '@ohos/frameworkwrapper';
import { EvtBus } from '@ohos/frameworkwrapper';
import { Log, SingletonHelper } from '@ohos/basicutils';
import { CommonUtils } from '@ohos/basicutils';
import { ArrayUtils } from '@ohos/basicutils';
import Display from '@ohos.display';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { UIContext } from '@kit.ArkUI';

const TAG = "SysUIDisplayManager";
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 事件类型，DisplayEvent
 */
const EVENT_DISPLAY = 1;

/**
 * 事件类型，左孔
 */
const EVENT_CUTOUT_LEFT = 2;

/**
 * 事件类型，中孔
 */
const EVENT_CUTOUT_MID = 3;

/**
 * 事件类型，右孔
 */
const EVENT_CUTOUT_RIGHT = 4;

/**
 * 事件类型，瀑布曲面
 */
const EVENT_WATERFALL = 5;

/**
 * 屏幕中间线误差值
 */
const MID_LINE_ERROR = 10;

/**
 * 混合事件
 */
type FixEvent = DisplayEvent | CutoutEvent | WaterfallEvent;

/**
 * 事件类
 */
type ClassEvent = new (...args: any[]) => FixEvent;

/**
 * 事件生产者
 */
type ProduceEvent = () => FixEvent;

/**
 * 屏幕常量
 */
export class DisplayConstants {
  /**
   * 默认display id
   */
  static readonly DEFAULT_DISPLAY: number = 0;

  /**
   * 无效display id
   */
  static readonly INVALID_DISPLAY: number = -1;

  /**
   * 屏幕方向未知
   */
  static readonly ORIENTATION_UNDEFINED: number = 0;

  /**
   * 屏幕方向竖屏
   */
  static readonly ORIENTATION_PORTRAIT: number = 1;

  /**
   * 屏幕方向横屏
   */
  static readonly ORIENTATION_LANDSCAPE: number = 2;

  /**
   * 屏幕挖孔的短边的最大长度，单位vp。
   * 超过该阈值认为是返回了pixel，则需要转换单位，用于兼容getDefaultDisplaySync获取的单位不一致的问题，待底座整改后删除。
   */
  static readonly CUTOUT_WIDTH_THRESHOLD_FOR_UNIT_CONVERT: number = 25;

  /**
   * DPI密度基数
   */
  public static readonly DEFAULT_DPI_DENSITY : number = 160;
}

/**
 * 中间孔信息
 */
export interface CutoutInfo {
  /**
   * 是否有中间孔
   */
  isMidCutout: boolean;
  /**
   * 中间孔宽度
   */
  midWidth: number;
};
/**
 * display屏幕管理
 *
 * @since 2022-09-16
 */
class DisplayManager {
  /**
   * 当前运行屏幕id
   */
  private displayId?: number;

  /**
   * 事件集
   * 事件类型标示 => 事件对象
   */
  private events: Map<number, FixEvent> = new Map();

  /**
   * 事件对应类集
   * 事件类型标示 => 事件类
   */
  private classes: Map<number, ClassEvent> = new Map();

  /**
   * 对应事件生产者集
   * 事件类型标示 => 事件生产者
   */
  private produces: Map<number, ProduceEvent> = new Map();
  /**
   * 存储有孔的数据
   */
  private cutoutMap: Map<number, ScreenRect> = new Map();

  private uiContext?: UIContext;

  /**
   * 构造
   */
  constructor() {
    // display属性变化事件
    let disEvent = new DisplayEvent();
    this.events.set(EVENT_DISPLAY, disEvent);
    this.classes.set(EVENT_DISPLAY, DisplayEvent);
    this.produces.set(EVENT_DISPLAY, (): DisplayEvent => disEvent);
    // 左孔区域事件
    let leftCutEvent = CutoutEvent.create(CutoutEvent.CUTOUT_LEFT, null);
    this.events.set(EVENT_CUTOUT_LEFT, leftCutEvent);
    this.classes.set(EVENT_CUTOUT_LEFT, CutoutEvent);
    this.produces.set(EVENT_CUTOUT_LEFT, (): CutoutEvent => leftCutEvent);
    // 中孔区域事件
    let midCutEvent = CutoutEvent.create(CutoutEvent.CUTOUT_MID, null);
    this.events.set(EVENT_CUTOUT_MID, midCutEvent);
    this.classes.set(EVENT_CUTOUT_MID, CutoutEvent);
    this.produces.set(EVENT_CUTOUT_MID, (): CutoutEvent => midCutEvent);
    // 右孔区域事件
    let rightCutEvent = CutoutEvent.create(CutoutEvent.CUTOUT_RIGHT, null);
    this.events.set(EVENT_CUTOUT_RIGHT, rightCutEvent);
    this.classes.set(EVENT_CUTOUT_RIGHT, CutoutEvent);
    this.produces.set(EVENT_CUTOUT_RIGHT, (): CutoutEvent => rightCutEvent);
    // 瀑布曲面屏曲面区域事件
    let waterEvent = new WaterfallEvent();
    this.events.set(EVENT_WATERFALL, waterEvent);
    this.classes.set(EVENT_WATERFALL, WaterfallEvent);
    this.produces.set(EVENT_WATERFALL, (): WaterfallEvent => waterEvent);
  }

  /**
   * display事件初始化
   */
  init(screenSession: SCBScreenSession): void {
    // 匹配当前display id
    this.displayId = screenSession?.session?.screenId;
    if (this.displayId === DisplayConstants.INVALID_DISPLAY) {
      this.displayId = DisplayConstants.DEFAULT_DISPLAY;
    }
    log.showDebug(`init current display id: ${this.displayId}`);
    // 初始display
    this.refreshCurrentDisplay(screenSession).then(() => this.afterUpdateCurrentDisplay());
    // 注册事件生产者
    this.produces.forEach((produce, eventType) => {
      EvtBus.produceOn(this.classes.get(eventType), produce);
    });
  }

  onScreenPropertyChange(screenSession: SCBScreenSession): void {
    // Screen属性变化
    log.showInfo(`onScreenChange: ${screenSession.session.screenId}`);
    if (screenSession.session.screenId === this.displayId) {
      log.showInfo(`display changed id: ${screenSession.session.screenId}`);
      this.refreshCurrentDisplay(screenSession).then(() => this.afterUpdateCurrentDisplay());
    }
  }

  /**
   * 直接获取缓存display，不用异步等待
   *
   * @return display(Nullable)
   */
  getCacheDisplay(): SCBScreenSession {
    return (this.getEvent(EVENT_DISPLAY) as DisplayEvent).display;
  }

  /**
   * 获取当前display
   *
   * @return 当前display
   */
  async getCurrentDisplay(): Promise<screenSessionManager.RRect> {
    let disEvent = this.getEvent(EVENT_DISPLAY) as DisplayEvent;
    return disEvent.display?.bounds;
  }

  /**
   * 获取屏幕最短宽度（较短）
   *
   * @return 屏幕最短宽度
   */
  async getShorterSide(): Promise<number> {
    let disEvent = this.getEvent(EVENT_DISPLAY) as DisplayEvent;
    if (!CommonUtils.isInvalid(disEvent?.display)) {
      return disEvent.getShorterSide();
    }
    return disEvent.getShorterSide();
  }

  /**
   * 刷新当前display
   */
  async refreshCurrentDisplay(screenSession: SCBScreenSession): Promise<void> {
    if (this.displayId === screenSession?.session.screenId) {
      log.showDebug(`refreshCurrentDisplay display: ${screenSession?.session?.screenId}`);
      let disEvent = this.getEvent(EVENT_DISPLAY) as DisplayEvent;
      disEvent.display = screenSession;
    }
  }

  /**
   * 当前display刷新完成
   */
  afterUpdateCurrentDisplay(): void {
    // 发送事件
    this.postEvent(EVENT_DISPLAY);
    // 获取屏幕挖孔
    try {
      let display = Display.getDefaultDisplaySync();
      if (CommonUtils.isInvalid(display)) {
        return;
      }
      // TODO 后续考虑使用 screenSessionManager
      display.getCutoutInfo().then((info) => {
        log.showDebug(`afterUpdateCurrentDisplay cutout: ${info.boundingRects.length}`);
        this.checkCutoutRect(display, info.boundingRects);
        this.checkWaterfallRect(info.waterfallDisplayAreaRects);
      });
    } catch (error) {
      log.error('error', error);
    }
  }

  /**
   * 检测挖孔位置
   * 数据从Display.getDefaultDisplaySync()获取
   *
   * @param dis 屏幕
   * @param boundRects 挖孔集
   * @todo 底座接口Display.getDefaultDisplaySync()返回的数据单位不统一，
   * ALN手机单位是pixel，其余是vp，此处有兼容判断isPixel，后续底座整改后需要删除。
   * @todo 此处的事件是通过registerPropertyChangeScenePanelCallback回调发送的，
   * 底座建议改为通过registerScreenPropertyChangeCallbacks回调发送。原因时当前使用的回调会有rotation和挖孔数据刷新不同步的问题。
   */
  private checkCutoutRect(dis: Display.Display, boundRects: Array<Display.Rect>): void {
    // 无孔
    if (ArrayUtils.isEmpty(boundRects)) {
      log.showInfo('checkCutoutRect has not cutout');
      this.checkPostNoCutoutEventBatch(new Set([
        EVENT_CUTOUT_LEFT,
        EVENT_CUTOUT_MID,
        EVENT_CUTOUT_RIGHT
      ]));
      return;
    }
    log.showInfo(`dis:${dis?.id}--${dis?.name}--${dis?.alive}--${dis?.width}--${dis?.height}. boundRects::${boundRects.length}`);

    let midLine = dis.width / 2;
    let screenRectArray: Array<ScreenRect> = new Array();
    boundRects.forEach((rect) => {
      let isPixel: boolean = Math.min(rect.width, rect.height) > DisplayConstants.CUTOUT_WIDTH_THRESHOLD_FOR_UNIT_CONVERT;
      if (isPixel) {
        log.showInfo('the unit of the return value is pixel.');
        screenRectArray.push({
          left: this.convertPixel2Vp(rect.left),
          top: this.convertPixel2Vp(rect.top),
          width: this.convertPixel2Vp(rect.width),
          height: this.convertPixel2Vp(rect.height)
        });
        midLine = this.convertPixel2Vp(midLine);
      } else {
        log.showWarn('the unit of the returned value is VP!');
        screenRectArray.push({
          left: rect.left,
          top: rect.top,
          width: rect.width,
          height: rect.height
        });
      }
    });

    this.checkCutoutRectInVp(midLine, screenRectArray);
  }

  private convertPixel2Vp(srcData: number): number {
    if (!this.uiContext) {
      return px2vp(srcData);
    }
    return this.uiContext.px2vp(srcData);
  }

  /**
   * 检测挖孔位置
   *
   * @param midLine 屏幕宽度中间线，单位vp
   * @param boundRects 挖孔集，单位vp
   */
  private checkCutoutRectInVp(midLine: number, boundRects: Array<ScreenRect>): void {
    log.showInfo(`midLine:${midLine}. boundRects:${boundRects.length}`);
    // 不判断孔的top，由业务根据窗口区域进行区分
    // 以宽度中间线为界，左右误差10，孔的中间点在左侧为左孔，在右侧为右孔，其他为中间孔
    let leftLine = midLine - MID_LINE_ERROR;
    let rightLine = midLine + MID_LINE_ERROR;
    let allType: Set<number> = new Set([
      EVENT_CUTOUT_LEFT,
      EVENT_CUTOUT_MID,
      EVENT_CUTOUT_RIGHT
    ]);
    const cutoutMap: Map<number, ScreenRect> = new Map(); // 存储有孔的数据
    boundRects.forEach((bound) => {
      let boundMidLine = bound.left + (bound.width / 2);
      // 区分左孔、右孔、中间孔
      let eventType = (boundMidLine < leftLine ? EVENT_CUTOUT_LEFT :
        (boundMidLine > rightLine ? EVENT_CUTOUT_RIGHT : EVENT_CUTOUT_MID));
      cutoutMap.set(eventType, bound);
      this.cutoutMap.set(eventType, bound);
      allType.delete(eventType);
    });
    // 先触发无孔数据，防止StatusBarVM -> checkStatusBarPadding因为未清除历史孔状态而算出错误的padding
    this.checkPostNoCutoutEventBatch(allType);
    // 后触发有孔数据
    cutoutMap.forEach((bound, eventType) => {
      this.checkPostCutoutChangeEvent(bound, eventType);
    });
  }

  /**
   * 获取是否有中间孔、中间孔宽度等数据
   *
   * @returns CutoutInfo: { isMidCutout: 是否有中间孔, midWidth: 中间孔宽度 }
   */
  public getCutoutInfo(): CutoutInfo {
    let midCutoutRect: ScreenRect | undefined = this.cutoutMap?.get(EVENT_CUTOUT_MID);
    let isMidCutout = !CommonUtils.isInvalidRect(midCutoutRect);
    return {
      isMidCutout: DeviceHelper.isPC() ? false : isMidCutout,
      midWidth: isMidCutout ? (midCutoutRect?.width ?? 0) : 0
    };
  }

  private checkPostNoCutoutEventBatch(cutoutEventTypes: Set<number>): void {
    cutoutEventTypes.forEach((eventType) => {
      this.checkPostCutoutChangeEvent({
        left: 0,
        top: 0,
        width: 0,
        height: 0
      }, eventType);
    });
  }

  /**
   * 检测瀑布曲面区域
   *
   * @param waterfallRects 瀑布曲面区域
   */
  private checkWaterfallRect(waterfallRects: Display.WaterfallDisplayAreaRects): void {
    // 无瀑布曲面
    if (CommonUtils.isInvalid(waterfallRects)) {
      return;
    }
    let waterEvent = this.getEvent(EVENT_WATERFALL) as WaterfallEvent;
    let oldRects = waterEvent.areaRects;
    if (CommonUtils.isInvalid(oldRects)) {
      waterEvent.areaRects = waterfallRects;
      this.postEvent(EVENT_WATERFALL);
      return;
    }
    // 对比是否变化
    if (CommonUtils.equalsRect(waterfallRects.left, oldRects.left) &&
    CommonUtils.equalsRect(waterfallRects.right, oldRects.right) &&
    CommonUtils.equalsRect(waterfallRects.top, oldRects.top) &&
    CommonUtils.equalsRect(waterfallRects.bottom, oldRects.bottom)) {
      return;
    }
    waterEvent.areaRects = waterfallRects;
    this.postEvent(EVENT_WATERFALL);
  }

  /**
   * 检测是否发送挖孔变化事件
   *
   * @param newRect 新挖孔区域
   * @param eventType 挖孔事假类型
   */
  private checkPostCutoutChangeEvent(newRect: ScreenRect, eventType: number): void {
    let cutEvent = this.getEvent(eventType) as CutoutEvent;
    // 无变化
    if (CommonUtils.equalsRect(cutEvent.cutoutRect, newRect)) {
      return;
    }
    // 有变化，发送变化事件
    cutEvent.cutoutRect = newRect;
    this.postEvent(eventType);
  }

  /**
   * 获取event对象
   *
   * @param eventType 类型
   */
  private getEvent(eventType: number): FixEvent {
    return this.events.get(eventType);
  }

  /**
   * 发送事件
   *
   * @param eventType 事件类型
   */
  private postEvent(eventType: number): void {
    EvtBus.post(this.classes.get(eventType), this.events.get(eventType));
    log.showInfo('postEvent post event change: ' + eventType);
  }

  /**
   * 设置处理屏幕数据时，px2vp需要的UIContext
   *
   * @param uiContext px2vp需要的UIContext
   * @returns 返回类自己
   */
  public setUiContext(uiContext: UIContext | undefined): void {
    if (uiContext) {
      this.uiContext = uiContext;
    }
    return;
  }

}

/**
 * display属性变化事件
 */
export class DisplayEvent {
  /**
   * 属性
   */
  display?: SCBScreenSession;



  /**
   * 当前是否为横屏，默认竖屏
   *
   * @return 是否横屏
   */
  isLand(): boolean {
    if (!this.display) {
      return false;
    }
    return this.display.bounds?.width > this.display.bounds?.height;
  }

  /**
   * 获取短边
   *
   * @return 短边长度
   */
  getShorterSide(): number {
    if (!this.display) {
      Log.showInfo('SysUIDisplayManager', 'getShorterSide display is null.');
      return 0;
    }
    return (this.display.bounds?.width > this.display.bounds?.height ?
      this.display.bounds?.height : this.display.bounds?.width) / 3.5;//this.display.densityPixels;
  }
}

Object.defineProperty(DisplayEvent, 'eventTypeName', { value: 'DisplayEvent' });

// 单例
export let DisplayMgr: DisplayManager = SingletonHelper.getInstance(DisplayManager, TAG);