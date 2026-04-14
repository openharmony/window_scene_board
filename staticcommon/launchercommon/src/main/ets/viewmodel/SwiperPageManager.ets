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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';

const TAG = 'SwiperPageManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 翻页类型
 */
export class SwiperPageType {
  public static readonly FOLDER_SWIPER = 'FOLDER_SWIPER';
  public static readonly DESKTOP_SWIPER = 'DESKTOP_SWIPER';
  public static readonly STOP_SWIPER = 'STOP_SWIPER';
}

/**
 * 注册、执行及销毁翻页回调函数的管理器
 */
export class SwiperPageManager {

  private swiperPageCallBackMap: Map<string, Function> = new Map();
  private preScreenData: number[] = [];
  private curScreenData: number[] = [];
  private screenData: number[][] = [];
  private animationNum: number = 0;
  private isFirstPowerOnTriple : boolean = true;

  /**
   * 获取 SwiperPageManager 单例
   * @returns SwiperPageManager实例
   */
  public static getInstance(): SwiperPageManager {
      return SingletonHelper.getInstance(SwiperPageManager, TAG);
  }

  /**
   * 设置是否为超大屏首次开机
   * @param isFirst
   */
  public setFirstPowerOnTriple(isFirst: boolean): void {
    this.isFirstPowerOnTriple = isFirst;
  }

  /**
   * 确定是否为超大屏首次开机
   * @returns true:首次 false:非首次
   */
  public getFirstPowerOnTriple(): boolean {
    return this.isFirstPowerOnTriple;
  }

  /**
   * 更新swiperPage与屏幕两侧的距离等信息
   * @param isCurrentState 是否是当前状态 F/M/G
   * @param workSpaceWidth 屏宽
   * @param marginLeft 左边距
   * @param marginRight 右边距
   * @param foldPaddingLeft 左填充
   * @param foldPaddingRight 右填充
   */
  public updateScreenData(isCurrentState: boolean, workSpaceWidth: number, marginLeft: number, marginRight: number,
    foldPaddingLeft: number, foldPaddingRight: number): void {
    let tempScreenData: number[] = [workSpaceWidth, Math.max(marginLeft, marginRight),
      Math.max(foldPaddingLeft, foldPaddingRight)];
    if (isCurrentState) {
      this.curScreenData = tempScreenData;
      this.screenData = [this.preScreenData, this.curScreenData];
      return;
    }
    this.preScreenData = tempScreenData;
    this.screenData = [this.preScreenData, this.curScreenData];
    return;
  }

  /**
   * 获取screen屏幕数据信息，包含当前状态和上一个状态
   * @returns 屏幕数据
   */
  public getScreenData(): number[][] {
    return this.screenData;
  }

  /**
   * G/M态场景下，统计做动画的swiperpage个数
   */
  public increaseAnimationNum(): void {
    this.animationNum++;
  }

  /**
   * 获取当前做动画的swiperPage个数
   * @returns number
   */
  public getAnimationNum(): number {
    return this.animationNum;
  }

  /**
   * 重置动画个数
   */
  public resetAnimationNum(): void {
    this.animationNum = 0;
  }

  /**
   * 注册翻页回调函数
   * @param type 翻页类型
   * @param callback 回调函数
   */
  registerSwiperPageCallback(type: string, callback: Function): void {
    log.info(`registerSwiperCallback type:${type}`);
    this.swiperPageCallBackMap.set(type, callback);
  }

  /**
   * 销毁翻页回调函数
   * @param type 翻页类型
   */
  unRegisterSwiperPageCallback(type: string, callback: Function): void {
    log.info(`unRegisterSwiperPageCallback type: ${type}`);
    if (this.swiperPageCallBackMap.has(type) && this.swiperPageCallBackMap.get(type) === callback) {
      this.swiperPageCallBackMap.delete(type);
    } else {
      log.info(`${type} has not swiperPageCallBack`);
    }
  }

  /**
   * 执行翻页回调函数
   * @param type 翻页类型
   * @param pageIndex 目标页
   */
  executeCallbackByType(type: string, pageIndex: number): void {
    log.info(`setSwiperPageIndex type: ${type}, index: ${pageIndex}`);
    let callback = this.swiperPageCallBackMap.get(type);
    if (callback) {
      callback(pageIndex);
    } else {
      log.showError('callback is null !');
    }
  }
}