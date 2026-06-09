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
import { util } from '@kit.ArkTS';

/**
 * 动效组件的布局参数
 */
@Observed
export class AnimationViewData {
  /**
   * 动效组件标识符
   */
  public key: string;

  /**
   * 动效组件宽度
   */
  public width: number = 0;

  /**
   * 动效组件imageFit 默认 Cover
   */
  public imageFit: number = 1;

  /**
   * 动效组件高度
   */
  public height: number = 0;

  /**
   * 动效组件圆角
   */
  public radius: number = 0;

  /**
   * 动效组件x方向位移
   */
  public translateX: number = 0;

  /**
   * 动效组件y方向位移
   */
  public translateY: number = 0;

  /**
   * 动效组件x初始偏移量
   */
  public offsetX: number = 0;

  /**
   * 动效组件y初始偏移量
   */
  public offsetY: number = 0;

  /**
   * 动效组件x松手时初始偏移量
   */
  public startOffsetX: number = 0;

  /**
   * 动效组件y松手时初始偏移量
   */
  public startOffsetY: number = 0;

  /**
   * 动效组件比例x大小
   */
  public scaleX: number = 1;

  /**
   * 动效组件比例y大小
   */
  public scaleY: number = 1;

    /**
   * 动效组件结束比例x大小
   */
  public endScaleX: number = 1;

  /**
   * 动效组件结束比例y大小
   */
  public endScaleY: number = 1;

  /**
   * 动效组件zIndex
   */
  public zIndex: number = 1;

  /**
   * 动效组件的旋转属性
   */
  public rotate: RotateOptions = { angle: 0 };

  /**
   * 动效组件是否有模糊效果
   */
  public useEffect: boolean = false;

  /**
   * 动效组件截图
   */
  public pixmap?: image.PixelMap;

  /**
   * 动效组件是否显示
   */
  public isShow: boolean = false;

  /**
   * 动效组件的透明度
   */
  public opacity: number = 1;

  /**
   * 动效组件唯一id，用于区分多次拖拽同一组件时生成的参数
   */
  private viewDataId: string = '';

  /**
   * 构造函数
   *
   * @param key 动效组件的标识符
   */
  public constructor(key: string) {
    this.key = key;
    this.viewDataId = util.generateRandomUUID();
  }

  /**
   * 将动效组件的布局属性转化为字符串
   *
   * @returns 转化得到的字符串
   */
  public toString(): string {
    return `AnimationViewData(${this.key}): { width:${this.width} height:${this.height} radius:${this.radius} ` +
      `translateX:${this.translateX} translateY:${this.translateY} offsetX:${this.offsetX} offsetY:${this.offsetY} ` +
      `scaleX:${this.scaleX} scaleY:${this.scaleY} rotate:${this.rotate.angle} useEffect:${this.useEffect} isShow:${this.isShow} }`;
  }
}

@Observed
export class AnimationViewDataList extends Array<AnimationViewData> {
}