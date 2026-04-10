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
import { FASlotName } from '@ohos/commonconstants';

export default class Constants {

  public static WINDOW_MARGIN_LEFT = 1338;
  public static WINDOW_MARGIN_TOP = 60;
  public static WINDOW_WIDTH = 360;
  public static WINDOW_HEIGHT = 466;
  public static readonly WINDOW_HEIGHT_FEW_TOGGLE = 380;
  public static WINDOW_HEIGHT_EDIT = 346;

  public static DEFAULT_WINDOW_WIDTH = 1706;
  public static readonly CURRENT_WINDOW_WIDTH = 2560;
  public static readonly CONTROL_PANEL_ID_SETTINGS = 'control_panel_id_settings';
  public static readonly CONTROL_PANEL_ID_PRIVACY_SENSOR = 'Ctrl.control_panel_id_privacy_sensor';

  public static readonly EDIT_MODE_BAR_COMPONENT_ID = 'edit_mode_bar';
  public static readonly EDIT_MODE_SELECTED_GRID_COMPONENT_ID = 'edit_mode_selected_grid';
  public static readonly EDIT_MODE_CANDIDATE_GRID_COMPONENT_ID = 'edit_mode_candidate_grid';
  public static readonly EDIT_MODE_PROMPT_COMPONENT_ID = 'edit_mode_prompt';
  public static TOGGLE_LIST_OF_2_2: string[] = [FASlotName.SUPER_DEVICE];
  public static QUICK_TOGGLE_DELETE_OF_PC_MODE: string[] =
    [FASlotName.AUTO_ROTATE];
  public static PC_MODE_QUICK_TOGGLE_MAX = 20;
  public static PC_MODE_QUICK_TOGGLE_MIN = 4;
  public static getEditGridComponentId(isSelected: boolean): string {
    if (isSelected) {
      return Constants.EDIT_MODE_SELECTED_GRID_COMPONENT_ID;
    }
    return Constants.EDIT_MODE_CANDIDATE_GRID_COMPONENT_ID;
  }
}