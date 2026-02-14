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

import { SystemUIUseScene } from '@ohos/systemuicommon/newTsIndex';
import { BaseVm } from '@ohos/systemuicommon/src/main/ets/vm/BaseVm';
import { BaseVmInjector } from '@ohos/systemuicommon/src/main/ets/vm/BaseVmInjector';
import { IFloatingBallInjector } from '../interface/IFloatingBallInjector';
import { IFloatingBallListVm } from '../interface/IFloatingBallListVm';
import { IFloatingBallMenuVm } from '../interface/IFloatingBallMenuVm';
import { IFloatingBallPanelVm } from '../interface/IFloatingBallPanelVm';
import { IFloatingBallRectVm } from '../interface/IFloatingBallRectVm';
import { FloatingBallListVm } from '../vm/FloatingBallListVm';
import { FloatingBallMenuVm } from '../vm/FloatingBallMenuVm';
import { FloatingBallPanelVm } from '../vm/FloatingBallPanelVm';
import { FloatingBallRectVm } from '../vm/FloatingBallRectVm';

export class FloatingBallInjector extends BaseVmInjector implements IFloatingBallInjector {
  public readonly scene = SystemUIUseScene.FLOATING_BALL;

  public static HOLDER = 0 as Object as FloatingBallInjector;

  public getPanelVm(): IFloatingBallPanelVm {
    return this.getVm(FloatingBallPanelVm.name, () => new FloatingBallPanelVm(this));
  }

  public getRectVm(): IFloatingBallRectVm {
    return this.getVm(FloatingBallRectVm.name, () => new FloatingBallRectVm(this));
  }

  public getListVm(): IFloatingBallListVm {
    return this.getVm(FloatingBallListVm.name, () => new FloatingBallListVm(this));
  }

  public getMenuVm(): IFloatingBallMenuVm {
    return this.getVm(FloatingBallMenuVm.name, () => new FloatingBallMenuVm(this));
  }

  public destroy(): void {
    this.foreachVm((vm) => {
      if (vm instanceof BaseVm) {
        vm.destroy();
      }
    });
    this.clearVm();
  }
}