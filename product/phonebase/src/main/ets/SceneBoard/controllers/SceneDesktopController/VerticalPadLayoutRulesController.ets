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
import { SingleContext, singleManager } from '@ohos/basicutils/src/main/ets/utils/SingleManager';
import { BaseConfig } from '@ohos/launchercommon';
import { DeviceHelper } from '@ohos/frameworkwrapper';

import { PadLayoutRulesController } from './PadLayoutRulesController';

const TAG = 'VerticalPadLayoutRulesController';

export class VerticalPadLayoutRulesController extends PadLayoutRulesController {
  public static singleName: string = 'VerticalPadLayoutRulesController';

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public static getInstance(baseConfig: BaseConfig, ctx?: SingleContext): VerticalPadLayoutRulesController {
    let instance = singleManager.get<VerticalPadLayoutRulesController>(VerticalPadLayoutRulesController, ctx);
    instance.initBaseConfig(baseConfig);
    return instance;
  }

  protected initBaseConfig(baseConfig: BaseConfig): void {
    if (this.mBaseConfig) {
      return;
    }
    super.initBaseConfig(baseConfig);
  }

  protected loadLauncherNewStyleConfig(): void {
    super.loadLauncherNewStyleConfig();
    // 行列数是将横屏的行列数值互换
    let column = this.columnNumOfGrid;
    this.columnNumOfGrid = this.rowNumOfGrid;
    this.rowNumOfGrid = column;
    this.spaceOfColumn = this.verticalSpace;
    this.spaceOfRow = this.verticalSpace;
    if (this.portraitSpaceOfColumn > 0) {
      this.spaceOfColumn = this.portraitSpaceOfColumn;
    }
    if (this.portraitSpaceOfRow > 0) {
      this.spaceOfRow = this.portraitSpaceOfRow;
    }
  }

  toString(): String {
    return TAG;
  }
}