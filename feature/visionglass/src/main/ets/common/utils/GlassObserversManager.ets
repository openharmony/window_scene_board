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

import { CallStatusManager } from '../manager/CallStatusManager';
import { visionGlassListener } from '../manager/VisionGlassListener';

/*
 * 统一管理眼镜桌面需要与手机桌面同声明周期的监听实例
 * */
export class GlassObserverManager {
  /*
   * 注册眼镜桌面相关监听实例
   * */
  public static initObservers(): void {
    visionGlassListener.initPolicy();
    CallStatusManager.getInstance().registerCallDetailsChangeCallback();
  }

  /*
   * 注销眼镜桌面相关监听实例
   * */
  public static unInitObservers(): void {
    visionGlassListener.unInit();
    CallStatusManager.getInstance().unRegisterCallDetailsChangeCallback();
    CallStatusManager.destroyInstance();
  }
}