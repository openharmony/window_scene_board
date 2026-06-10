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
import { ImmersiveConstants } from '../../common/ImmersiveConstants';


/**
 * 沉浸面板状态
 */
@Observed
export class ImmersivePanelState {
  /**
   * 面板高度
   */
  public height: number | string = '100%';

  /**
   * top间距值
   */
  public paddingTop: number | string = ImmersiveConstants.getNtfListPaddingTop();

  /**
   * bottom间距值
   */
  public paddingBottom: number = ImmersiveConstants.getNtfListPaddingBottom();

  /**
   * margin top间距值
   */
  public marginTop: number | string = '16vp';

  /**
   * 沉浸列表底部padding
   */
  public listBottomPadding: number = 0;

  /**
   * 列表对齐
   */
  public listAlign: Alignment = Alignment.Bottom;

  /**
   * 重置顶部边距值
   */
  public resetPaddingTop(): void {
    this.paddingTop = ImmersiveConstants.getNtfListPaddingTop();
  }
}