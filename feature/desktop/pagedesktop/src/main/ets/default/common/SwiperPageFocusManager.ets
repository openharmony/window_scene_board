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
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'SwiperPageFocusManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 桌面组件焦点管理类
 */
export class SwiperPageFocusManager {
  private currentFocusComponentId: string = '';
  private static instance: SwiperPageFocusManager;
  private isRotation: boolean = false;

  /**
   * 获取SwiperPageFocusManager单例
   *
   * @returns SwiperPageFocusManager 单例对象
   */
  public static getInstance(): SwiperPageFocusManager {
    if (!SwiperPageFocusManager.instance) {
      SwiperPageFocusManager.instance = new SwiperPageFocusManager();
    }
    return SwiperPageFocusManager.instance;
  }

  private setIsRotation(isRotation: boolean): void {
    this.isRotation = isRotation;
  }

  /**
   * 获取是否旋转
   *
   * @returns true:屏幕旋转后
   */
  public getIsRotation(): boolean {
    return this.isRotation;
  }

  /**
   * 设置记录当前焦点ID以及旋转状态
   *
   * @param focusComponentID 获焦组件ID
   * @param isRotation true:屏幕旋转后
   */
  public setFocusComponentId(focusComponentID: string, isRotation: boolean): void {
    log.info(`setFocusComponentId:${focusComponentID}, isRotation:${isRotation}`);
    this.currentFocusComponentId = focusComponentID;
    this.setIsRotation(isRotation);
  }

  /**
   * 获取当前焦点ID
   *
   * @returns 返回获焦组件ID
   */
  public getFocusComponentId(): string {
    log.info(`getFocusComponentId isRotation:${this.isRotation}, currentFocusComponentId:${this.currentFocusComponentId}`);
    return this.currentFocusComponentId;
  }

  /**
   * 在横竖屏旋转后设置焦点ID
   */
  public setFocusComponentIdAfterRotation(): void {
    let focusId: string = this.getFocusComponentId();
    if (focusId !== '') {
      this.setFocusComponentId(focusId, true);
      log.info(`setRotationFocusComponent requestFocus focusId:${focusId}`);
    }
  }
}