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

import { DragConstants } from '@ohos/commonconstants';
import curves from '@ohos.curves';
import { DropAnimationDestination } from '../config/DropAnimationConfig';

/**
 * 落位动效参数
 */
export class DropAnimationParam {
  /**
   * 落位元素的标识符
   */
  public key: string = '';

  /**
   * 起始点x坐标
   */
  public startX: number = 0;

  /**
   * 起始点y坐标
   */
  public startY: number = 0;

  /**
   * 终点x坐标
   */
  public endX: number = 0;

  /**
   * 终点y坐标
   */
  public endY: number = 0;

  /**
   * 落位元素最终的宽度
   */
  public endWidth: number = 0;

  /**
   * 落位元素最终的高度
   */
  public endHeight: number = 0;

  /**
   * 落位元素最终的圆角
   */
  public endRadius: number = 0;

  /**
   * 落位元素最终的比例大小 x
   */
  public endScaleX: number = 0;

  /**
   * 落位元素最终的比例大小 y
   */
  public endScaleY: number = 0;

  /**
   * 落位元素最终的旋转属性
   */
  public endRotate: RotateOptions = { angle: 0 };

  /**
   * 落位动效延迟时间 ms
   */
  public delay: number = 0;

  /**
   * 落位动效时长
   */
  public duration: number | undefined = undefined;

  /**
   * 落位动效曲线
   */
  public curve: curves.ICurve = DragConstants.DROP_CURVES;

  /**
   * 落位元素最终不透明度
   */
  public endOpacity: number = 1;

  /**
   * 落位开始时的宽度
   */
  public startWidth: number = 0;

  /**
   * 落位开始时的高度
   */
  public startHeight: number = 0;

  /**
   * 并行动画
   */
  public parallelAnimation?: () => void;

  /**
   * 构造函数
   *
   * @param key 落位元素标识符
   * @param startX 落位动效起点x
   * @param startY 落位动效起点y
   * @param endX 落位动效终点x
   * @param endY 落位动效终点y
   */
  public constructor(key: string, startX: number, startY: number, endX: number, endY: number) {
    this.key = key;
    this.startX = startX;
    this.startY = startY;
    this.endX = endX;
    this.endY = endY;
  }

  /**
   * 将落位动效的参数转化为字符串
   *
   * @returns 转化得到的字符串
   */
  public toString(): string {
    return `DropAnimationParam(${this.key}): { startX:${this.startX} startY:${this.startY} endX:${this.endX} ` +
      `endY:${this.endY} width:${this.endWidth} height:${this.endHeight} radius:${this.endRadius} ` +
      `scaleX:${this.endScaleX} scaleY:${this.endScaleY} rotate:${this.endRotate.angle} ` +
      `startWidth:${this.startWidth} startHeight:${this.startHeight}`;
  }
}

/**
 * 动效完成回调
 */
export enum animationResult {
  CANCEL = 'cancel',
  FINISH = 'finish',
  NOT_START = 'notStart'
}

/**
 * 多组件动效参数 animateTo方案
 */
export interface MultiAnimationParam {
  target: DropAnimationDestination;
  /** 落位动效参数列表 */
  paramList: DropAnimationParam[] | DropAnimationExParam[];
  /** 动效全部完成回调 */
  onAnimationEnd?: (isCancel: boolean, paramList: DropAnimationParam[] | DropAnimationExParam[]) => void;
  /** 单个动效开始回调 */
  onAnimationItemStart?: (param: DropAnimationParam | DropAnimationExParam) => void;
  /** 单个动效完成回调 */
  onAnimationItemEnd?: (param: DropAnimationParam | DropAnimationExParam, isCancel: boolean) => void;
  /** 动效结束时释放动效组件 */
  releaseOnEnd?: boolean;
}
/**
 *  落位动效参数 animateExTo方案
 */
export class DropAnimationExParam {
  /**
   * 落位元素的标识符
   */
  public key: string;

  /**
   * 起始点x坐标
   */
  public startX: number;

  /**
   * 起始点y坐标
   */
  public startY: number;

  /**
   * 默认动效时长 ms
   */
  public duration: number = 1000;

  /**
   * 默认动效曲线
   */
  public curve: curves.ICurve = DragConstants.DROP_CURVES;

  /**
   * 动效列表
   */
  public eventList: DropAnimationExEvent[] = [];

  /**
   * 动效类型
   */
  public type?: number = 0;

  constructor(key: string, startX: number, startY: number, eventList: DropAnimationExEvent[]) {
    this.key = key;
    this.startX = startX;
    this.startY = startY;
    this.eventList = eventList;
  }

  /**
   * 将落位动效的参数转化为字符串
   *
   * @returns 转化得到的字符串
   */
  public toString(): string {
    let eventString = '';
    this.eventList.forEach((event: DropAnimationExEvent) => {
      eventString += event.toString();
    });
    return `DropAnimationExParam(${this.key}): { startX:${this.startX} startY:${this.startY}` +
      ` duration:${this.duration} eventList:${eventString} }`;
  }
}

/**
 *  animateExTo方案 落位动效子事件参数
 */
export class DropAnimationExEvent {
  /** 落位动效延迟时间 ms */
  public delay?: number;

  /** 落位动效时长 */
  public duration?: number;

  /** 落位动效曲线 */
  public curve?: curves.ICurve | Curve;

  /** 终点x坐标 */
  public endX?: number;

  /** 终点y坐标 */
  public endY?: number;

  /** 落位元素最终的宽度 */
  public endWidth?: number;

  /** 落位元素最终的高度 */
  public endHeight?: number;

  /** 落位元素最终的圆角 */
  public endRadius?: number;

  /** 落位元素最终的比例大小 x */
  public endScaleX?: number;

  /** 落位元素最终的比例大小 y */
  public endScaleY?: number;

  /** 落位元素最终的旋转属性 */
  public endRotate?: RotateOptions;

  /** 落位元素最终不透明度 */
  public endOpacity?: number;

  /**
   * 将落位动效的参数转化为字符串
   *
   * @returns 转化得到的字符串
   */
  public toString(): string {
    return `DropAnimationExEvent: { delay:${this.delay} duration:${this.duration} endX:${this.endX}` +
      ` endY:${this.endY} endWidth:${this.endWidth} endHeight:${this.endHeight} endRadius:${this.endRadius}` +
      ` endScaleX:${this.endScaleX} endScaleY:${this.endScaleY} endOpacity:${this.endOpacity}` +
      ` endRotate:${this.endRotate?.angle} };`;
  }
}
