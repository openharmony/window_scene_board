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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AnyColor, EDIT_COLOR_ARRAY } from '../models/AnyColor';
import { SlEditorBindState } from '../models/SlEditorBindState';
import { LayoutEditManager } from '../viewmodel/LayoutEditManger';
import { slStateHelper } from '../../common/utils/SlStateHelper';
import { CLOCK_DEFAULT_FOREGROUND_COLOR } from '../models/AnyClock';
import { Constants } from './Contants';

const TAG: string = 'EditSheetHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class EditSheetHelper {
  // 编辑器UI绑定状态
  private editorUiBindState: SlEditorBindState = slStateHelper.getEditorBindState();

  // 时钟样式编辑VM
  private layoutEditorManger: LayoutEditManager = new LayoutEditManager();


  /**
   * 获取样式编辑VM
   */
  public getLayoutEditManger(): LayoutEditManager {
    return this.layoutEditorManger;
  }

  /**
   * 获取锁屏编辑面板的UI绑定状态
   */
  public getEditorBindState(): SlEditorBindState {
    return this.editorUiBindState;
  }

  public getEditColorArray(): Array<AnyColor> {
    return EDIT_COLOR_ARRAY;
  }

  public getTargetColorIndex(color: string): number {
    let colorValue: string = color.replace(Constants.MULTI_CLOCK_ALPHA, Constants.COLOR_BTN_ALPHA);

    if (color === CLOCK_DEFAULT_FOREGROUND_COLOR) {
      return 0;
    }
    for (let i = 0; i < EDIT_COLOR_ARRAY.length; i++) {
      if (EDIT_COLOR_ARRAY[i].color === colorValue) {
        return i + 1;
      }
    }
    return 0;
  }
}

export let slEditorHelper: EditSheetHelper = new EditSheetHelper();

