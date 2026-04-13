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
import { UIContext } from '@kit.ArkUI';

/**
 * 锁屏Context相关转换
 */
class SlContextHelper {
  // 锁屏环境
  private _uiContext?: UIContext;

  /**
   * 缓存锁屏环境
   *
   * @param uiContext 锁屏环境
   */
  public setUiContext(uiContext?: UIContext): void {
    this._uiContext = uiContext;
  }

  /**
   * 取值环境
   *
   * @returns 环境
   */
  public getUiContext(): UIContext | undefined {
    return this._uiContext;
  }

  /**
   * px转换vp
   *
   * @param value 目标值
   * @returns 转换值
   */
  public px2vp(value: number): number {
    if (this._uiContext) {
      return this._uiContext.px2vp(value);
    } else {
      return px2vp(value);
    }
  }

  /**
   * vp转换px
   *
   * @param value 目标值
   * @returns 转换值
   */
  public vp2px(value: number): number {
    if (this._uiContext) {
      return this._uiContext.vp2px(value);
    } else {
      return vp2px(value);
    }
  }

  /**
   * px转换fp
   *
   * @param value 目标值
   * @returns 转换值
   */
  public px2fp(value: number): number {
    if (this._uiContext) {
      return this._uiContext.px2fp(value);
    } else {
      return px2fp(value);
    }
  }

  /**
   * fp转换px
   *
   * @param value 目标值
   * @returns 转换值
   */
  public fp2px(value: number): number {
    if (this._uiContext) {
      return this._uiContext.fp2px(value);
    } else {
      return fp2px(value);
    }
  }
}

// 单例
export const slCtxHelper: SlContextHelper = new SlContextHelper();