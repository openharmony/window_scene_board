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
import deviceInfo from '@ohos.deviceInfo';
import { Log } from '@ohos/basicutils';

/**
 * 拖拽的数据类型
 */
export enum DragDataType {
  /**
   * 应用图标类型
   */
  APP = 'scb_app',

  /**
   * dock图标类型
   */
  DOCK_APP = 'scb_dock_app',

  /**
   * 文件夹类型，该类型拖拽时底座会在拖拽过程中设置模糊
   */
  FOLDER = 'scb_folder',

  /**
   * 卡片类型
   */
  FORM = 'scb_form',

  /**
   * 卡片堆叠类型
   */
  FORM_STACK = 'scb_form_stack',

  /**
   * pc文件文件夹类型
   */
  PC_FILE = 'scb_file',

  /**
   * 分区文件夹类型
   */
  REGION_FOLDER = 'scb_region_folder',
}

/**
 * 用于构造拖拽的额外信息，在onDragStart等接口中返回
 */
export class DragExtraInfo {
  /**
   * 拖拽数据类型
   */
  private dragDataType: DragDataType;

  /**
   * 拖拽时的模糊参数
   */
  private dragBlurStyle?: number;

  /**
   * 拖拽时的圆角
   */
  private dragRadius?: number;

  /**
   * 是否支持跨设备拖拽，桌面元素默认不支持
   */
  private isDragAllowDistributed: boolean = false;

  /**
   * 发起拖拽的设备号
   */
  private deviseSN?: string;

  /**
   * 拖拽预览图偏移X, 用于解决大文件夹长按菜单跳变问题
   */
  private dragOffsetX?: number;

  /**
   * 拖拽预览图偏移Y, 用于解决大文件夹长按菜单跳变问题
   */
  private dragOffsetY?: number;

  /**
   * 构造函数
   *
   * @param dragDataType 拖拽数据类型
   */
  public constructor(dragDataType: DragDataType) {
    this.dragDataType = dragDataType;
  }

  /**
   * 设置拖拽模糊参数
   *
   * @param blurStyle 模糊参数
   * @returns 拖拽额外信息实例
   */
  public setBlurStyle(blurStyle: number): this {
    this.dragBlurStyle = blurStyle;
    return this;
  }

  /**
   * 设置sn设备号
   *
   * @param
   * @returns
   */
  public setDeviceSn(deviseSN: string): this {
    this.deviseSN = deviseSN;
    return this;
  }

  /**
   * 设置拖拽的圆角
   *
   * @param radius 圆角参数
   * @returns 拖拽额外信息实例
   */
  public setRadius(radius: number): this {
    this.dragRadius = radius;
    return this;
  }

  /**
   * 设置拖拽预览图偏离X
   *
   * @param offsetX 偏离量X
   * @returns 拖拽额外信息实例
   */
  public setDragOffsetX(offsetX: number): this {
    this.dragOffsetX = offsetX;
    return this;
  }

  /**
   * 设置拖拽预览图偏离Y
   *
   * @param offsetY 偏离量Y
   * @returns 拖拽额外信息实例
   */
  public setDragOffsetY(offsetY: number): this {
    this.dragOffsetY = offsetY;
    return this;
  }

  /**
   * 设置拖拽是否支持跨设备
   *
   * @param isDragAllowDistributed 拖拽是否支持跨设备
   * @returns 拖拽额外信息实例
   */
  public setAllowDistributed(isDragAllowDistributed: boolean): this {
    this.isDragAllowDistributed = isDragAllowDistributed;
    return this;
  }

  /**
   * 将拖拽的额外信息转化为字符串，起拖时传递给底座
   *
   * @returns 拖拽额外信息转化的字符串
   */
  public toString(): string {
    let infoStr: string = `{ "drag_data_type": "${this.dragDataType}", `;
    if (this.dragBlurStyle != null) {
      infoStr += `"drag_blur_style": ${this.dragBlurStyle}, `;
    }
    if (this.dragRadius != null) {
      infoStr += `"drag_corner_radius": ${this.dragRadius}, `;
    }
    if (this.deviseSN != null) {
      infoStr += `"drag_from_device": "${this.deviseSN}", `;
    }
    if (this.dragOffsetX != null) {
      infoStr += `"drag_offset_x": ${this.dragOffsetX}, `;
    }
    if (this.dragOffsetY != null) {
      infoStr += `"drag_offset_y": ${this.dragOffsetY}, `;
    }
    infoStr += `"fromDesktop": true, `;
    infoStr += `"drag_allow_distributed": ${this.isDragAllowDistributed} }`;
    return infoStr;
  }
}
