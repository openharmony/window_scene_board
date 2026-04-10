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
import { ResUtils } from '@ohos/windowscene';
import StyleConfiguration, {
  ControlCenterQuickToggleLayoutStyle
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/StyleConfiguration';

export interface EditModeStyleParam {
  rowsGap?: number;
  colsGap?: number;
  margin?: Margin | Length | LocalizedMargin;
  padding?: Margin | Length | LocalizedMargin;
  height?: Length;
  width?: Length;
  border?: BorderOptions;
  maxCount?: number;
  size?: string | number | Resource | SizeOptions;
  contentColor?: ResourceColor;
}

export class EditModeCommonStyle {
  private static mInstance: EditModeCommonStyle;
  private toggleStyle: ControlCenterQuickToggleLayoutStyle =
    StyleConfiguration.getControlCenterQuickToggleLayoutStyle();

  public static getInstance(): EditModeCommonStyle {
    if (!EditModeCommonStyle.mInstance) {
      EditModeCommonStyle.mInstance = new EditModeCommonStyle();
    }
    return EditModeCommonStyle.mInstance;
  }

  public getGridParam(isSelected: boolean): EditModeStyleParam {
    if (isSelected) {
      return SelectedGridStyle.getInstance();
    }
    return CandidateGridStyle.getInstance();
  }

  public getItemWidth(): number {
    return this.toggleStyle.buttonDiameter + this.toggleStyle.newIconPadding * 2;
  }

  public getItemHeight(): number {
    return this.toggleStyle.buttonDiameter + this.toggleStyle.buttonLabelSpace +
    this.toggleStyle.buttonLabelHeight + this.toggleStyle.newIconPadding;
  }
}

export class SelectedGridStyle implements EditModeStyleParam {
  private static mInstance: SelectedGridStyle;
  public rowsGap: number = ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_grid_rowsGap'));
  public colsGap: number = ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_grid_colsGap'));
  public margin: Margin | Length | LocalizedMargin = {
    left: ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_selected_grid_margin_left')),
    right: ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_selected_grid_margin_right'))
  };
  public padding: Margin | Length | LocalizedMargin = {
    left: ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_selected_grid_padding_left')),
    right: ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_selected_grid_padding_right')),
    top: ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_selected_grid_padding_top')),
    bottom: ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_selected_grid_padding_bottom'))
  };
  public border: BorderOptions = {
    radius: ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_selected_grid_border_radius')),
    width: ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_selected_grid_border_width')),
    color: $r('sys.color.comp_background_primary_contrary'),
    style: BorderStyle.Solid,
  };
  public maxCount: number = 10;

  public static getInstance(): SelectedGridStyle {
    if (!SelectedGridStyle.mInstance) {
      SelectedGridStyle.mInstance = new SelectedGridStyle();
    }
    return SelectedGridStyle.mInstance;
  }
}

export class CandidateGridStyle implements EditModeStyleParam {
  private static mInstance: CandidateGridStyle;
  public rowsGap: number = ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_grid_rowsGap'));
  public colsGap: number = ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_grid_colsGap'));
  public padding: Margin | Length | LocalizedMargin = {
    left: ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_candidate_grid_padding_left')),
    right: ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_candidate_grid_padding_right')),
    bottom: ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_candidate_grid_padding_bottom'))
  };

  public static getInstance(): CandidateGridStyle {
    if (!CandidateGridStyle.mInstance) {
      CandidateGridStyle.mInstance = new CandidateGridStyle();
    }
    return CandidateGridStyle.mInstance;
  }
}

export class EditModeBarStyle implements EditModeStyleParam {
  private static mInstance: EditModeBarStyle;
  ;
  public btnWidth: number = ResUtils.getConvertNumber($r('app.float.Control_center_edit_symbol_icon_size'));
  public btnHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_edit_symbol_icon_size'));
  public btnWrapperWidth: number = ResUtils.getConvertNumber($r('app.float.Control_center_header_btn_wrapper_width'));
  public btnWrapperHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_header_btn_wrapper_height'));
  public btnColor: string = '#b3000000';
  public leftBtnMarginLeft: number =
    ResUtils.getConvertNumber($r('app.float.Control_center_header_back_btn_margin_left'));
  public rightBtnMarginRight: number =
    ResUtils.getConvertNumber($r('app.float.Control_center_header_back_btn_margin_right'));
  public titleMarginLeft: number =
    ResUtils.getConvertNumber($r('app.float.Control_center_header_edit_mode_title_margin_left'));
  public titleWidth: number = ResUtils.getConvertNumber($r('app.float.Control_center_header_edit_mode_title_width'));
  public titleHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_head_height'));
  public height: number = ResUtils.getConvertNumber($r('app.float.Control_center_edit_header_height'));

  public static getInstance(): EditModeBarStyle {
    if (!EditModeBarStyle.mInstance) {
      EditModeBarStyle.mInstance = new EditModeBarStyle();
    }
    return EditModeBarStyle.mInstance;
  }
}

export class EditModePromptStyle implements EditModeStyleParam {
  private static mInstance: EditModePromptStyle;
  public width: Length = ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_prompt_width'));
  public margin: Margin | Length | LocalizedMargin = {
    top: ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_prompt_margin_top')),
    bottom: ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_prompt_margin_bottom'))
  };
  public size: string | number | Resource = $r('app.float.Control_center_edit_mode_prompt_fontSize');
  public contentColor: ResourceColor = $r('sys.color.font_secondary');

  public static getInstance(): EditModePromptStyle {
    if (!EditModePromptStyle.mInstance) {
      EditModePromptStyle.mInstance = new EditModePromptStyle();
    }
    return EditModePromptStyle.mInstance;
  }
}

export class EditModeActionBtnStyle implements EditModeStyleParam {
  private static mInstance: EditModeActionBtnStyle;
  public size: SizeOptions = {
    height: $r('app.float.Control_center_edit_mode_action_btn_size'),
    width: $r('app.float.Control_center_edit_mode_action_btn_size'),
  };
  public margin: Padding | Length | LocalizedPadding = {
    top: ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_action_btn_margin_top')),
    right: ResUtils.getConvertNumber($r('app.float.Control_center_edit_mode_action_btn_margin_right'))
  };

  public static getInstance(): EditModeActionBtnStyle {
    if (!EditModeActionBtnStyle.mInstance) {
      EditModeActionBtnStyle.mInstance = new EditModeActionBtnStyle();
    }
    return EditModeActionBtnStyle.mInstance;
  }
}