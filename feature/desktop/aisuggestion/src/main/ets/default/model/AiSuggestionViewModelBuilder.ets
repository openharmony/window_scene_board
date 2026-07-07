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

import { GridLayoutItemInfo } from '@ohos/launchercommon';
import { AiSuggestionComponentData } from '../bean/AiSuggestionComponentData';
import { AiSuggestionLayoutStyle } from '../config/AiSuggestionLayoutStyle';
import { AiSuggestionViewModel } from './AiSuggestionViewModel';

/**
 * 语音助手建议AiSuggestionComponent组件Vm Builder
 *
 * @since 2025-05-27
 */
export class AiSuggestionViewModelBuilder {
  private viewModel: AiSuggestionViewModel;

  public constructor(viewModel?: AiSuggestionViewModel) {
    if (viewModel) {
      this.viewModel = viewModel;
    } else {
      this.viewModel = new AiSuggestionViewModel();
    }
  }

  public setFormItem(formItem: GridLayoutItemInfo): AiSuggestionViewModelBuilder {
    this.viewModel.formItem = formItem;
    return this;
  }

  public setCardId(cardId: string): AiSuggestionViewModelBuilder {
    this.viewModel.cardId = cardId;
    return this;
  }

  public setViewData(viewData: AiSuggestionComponentData): AiSuggestionViewModelBuilder {
    this.viewModel.viewData = viewData;
    return this;
  }

  public isOuterDesktop(isOuterDesktop: boolean): AiSuggestionViewModelBuilder {
    this.viewModel.isOuterDesktop = isOuterDesktop;
    return this;
  }

  public setLayoutStyle(layoutStyle?: AiSuggestionLayoutStyle): AiSuggestionViewModelBuilder {
    this.viewModel.layoutStyle = layoutStyle;
    return this;
  }

  public isFormStackChildItem(isFormStackChildItem: boolean): AiSuggestionViewModelBuilder {
    this.viewModel.isFormStackChildItem = isFormStackChildItem;
    return this;
  }

  public setDeleteFormFunction(deleteForm?: Function): AiSuggestionViewModelBuilder {
    this.viewModel.deleteForm = deleteForm;
    return this;
  }

  public isUseEffectFunction(isUseEffect?: Function): AiSuggestionViewModelBuilder {
    this.viewModel.isUseEffect = isUseEffect;
    return this;
  }

  public isDuringAppExitAnim(isDuringAppExitAnim?: Function): AiSuggestionViewModelBuilder {
    this.viewModel.isDuringAppExitAnimFunction = isDuringAppExitAnim;
    return this;
  }

  public setUpdateAppNameFunction(updateAppName?: Function): AiSuggestionViewModelBuilder {
    this.viewModel.updateAppName = updateAppName;
    return this;
  }

  public setUpdateCardSuccess(updateCardSuccess?: Function): AiSuggestionViewModelBuilder {
    this.viewModel.updateCardSuccess = updateCardSuccess;
    return this;
  }

  /**
   * 长按获取壁纸函数回调
   *
   * @param getCropWallPaperPixelMap 获取壁纸函数
   * @returns AiSuggestionViewModelBuilder
   */
  public setGetCropWallPaperPixelMap(getCropWallPaperPixelMap?: Function): AiSuggestionViewModelBuilder {
    this.viewModel.getCropWallPaperPixelMap = getCropWallPaperPixelMap;
    return this;
  }

  public build(): AiSuggestionViewModel {
    return this.viewModel;
  }
}