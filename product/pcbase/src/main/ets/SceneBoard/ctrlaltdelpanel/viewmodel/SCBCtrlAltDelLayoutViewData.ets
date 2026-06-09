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
import Constants from '../common/Constants'

@Observed
export class SCBCtrlAltDelLayoutViewData {
  /**
   * @description 功能键上边距
   */
  public functionMarginTop: number = Constants.FUNCTION_MARGIN_TOP;
  /**
   * @description 取消键上边距
   */
  public cancelViewMarginTop: number = Constants.CANCLE_VIEW_MARGIN_TOP;
}