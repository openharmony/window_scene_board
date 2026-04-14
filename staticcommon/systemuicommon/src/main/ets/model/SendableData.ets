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
'use shared';

interface LRTBRect {
  left: number,
  right: number,
  top: number,
  bottom: number,
}

@Sendable
class SendableRectInfo {
  public x: number = 0;
  public y: number = 0;
  public width: number = 0;
  public height: number = 0;

  public update(rect: RectResult): void {
    this.x = rect.x;
    this.y = rect.y;
    this.width = rect.width;
    this.height = rect.height;
  }

  public updateByLRTBRect(rect: LRTBRect): void {
    this.x = rect.left;
    this.y = rect.top;
    this.width = rect.right - rect.left;
    this.height = rect.bottom - rect.top;
  }

  public convert2LRTBRect(): LRTBRect {
    return {
      left: this.x,
      right: this.x + this.width,
      top: this.y,
      bottom: this.y + this.height
    }
  }
}

@Sendable
class SharedData {
  /**
   * 状态栏窗口ID
   */
  public statusBarPersistentId: number = 0;

  /**
   * 状态栏窗口宽度
   */
  public statusBarWidth: number = 0;

  /**
   * 状态栏窗口高度
   */
  public statusBarHeight: number = 0;

  /**
   * 状态栏窗口所在的屏幕ID
   */
  public statusBarScreenId: number = 0;

  /**
   * 状态栏显隐标记
   */
  public isStatusBarShow: boolean = false;

  /**
   * 下拉面板窗口ID
   */
  public dropdownPersistentId: number = 0;

  /**
   * 下拉面板窗口显隐标记
   */
  public isDropDownShow: boolean = false;

  /**
   * 横幅窗口ID
   */
  public bannerPersistentId: number = 0;

  /**
   * 横幅窗口所在的屏幕ID
   */
  public bannerScreenId: number = 0;

  /**
   * 横幅窗口宽度
   */
  public bannerScreenWidth: number = 0;

  /**
   * 横幅窗口是否显示
   */
  public isBannerShow: boolean = false;

  /**
   * 是否在应用一镜到底动效
   */
  public isStartAppOneMirror: boolean = false;

  /**
   * 是否正在执行动效（实况场景使用）
   */
  public isExecuting: boolean = false;

  /**
   * 点击实况卡片的rect信息
   */
  public clickCardRect: SendableRectInfo = new SendableRectInfo();

  /**
   * 沉浸态实况卡片的rect信息
   */
  public immersiveCardRect: SendableRectInfo = new SendableRectInfo();

  public isAodShowNtf: boolean = false;

  public isAodShowCapsule: boolean = false;

  public aodNtfId: string = '';

  public aodCapsuleId: string = '';

  public aodNtfRect: SendableRectInfo = new SendableRectInfo();

  public aodCapsuleRect: SendableRectInfo = new SendableRectInfo();
}

export const sharedData = new SharedData();