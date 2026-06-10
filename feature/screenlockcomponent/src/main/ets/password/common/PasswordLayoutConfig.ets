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

import PasswordConstants from './PasswordConstants';

const PASSWORD_MASK_SPACE = 24;
const OUTER_PASSWORD_MASK_SPACE = 20;

export interface PSDLayoutConfig {
  // Outer screen flag
  outerScreenFlag: boolean;
  // InputTips param
  mixedPasswordFaceImageTipSize : Resource;
  mixedPasswordFaceImageTipMargin : Resource;
  inputPwdTipWithFaceMarginTop : Resource;
  inputPwdTipMarginTop : Resource;
  inputPwdTipMinFontSize : Resource;
  inputPwdTipMaxFontSize : Resource
  // Numkeyboard param
  numkeyboardGridItemStackSize : Resource;
  numKeyboardGridItemBgRadius : Resource;
  numKeyboardLetterTextHeight: Resource;
  numKeyboardBackHeight: Resource;
  numKeyboardBgWidthHeight: Resource;
  numKeyboardSpecialKeyBgRadius: Resource;
  numBoardHeight: number;
  numBoardTopMarginPhone: number;
  numBoardLeftMarginPhone: number;
  plusSignFontSize : Resource;
  letterTextFontSize : Resource;
  specialFontSize : Resource;
  numberFontSize : Resource;
  // PasswdMask param
  passwdMaskSpace : number;
  passwdMaskDotWidthAndHeight : Resource;
  // DigitalPSD param
  digitalPwdMaskMarginTop : Resource;
  digitalKeyBoardMarginTop : Resource;
  // MixedPSD param
  mixedEmergencyCallVisibility : boolean;
  mixedTextInputHeight: Resource;
  mixedTextInputMarginTop: Resource;
  mixedPwdCombinationHeight: Resource;
  // SIMCardPSD param
  simCardFlagVisibility : boolean;
  simCardInputTipsFontSize: number;
  simCardInputTipsHeight: Resource;
  simCardPukLockedTipsFontSize: number;
  simCardPukLockedTipsTipsHeight: Resource;
  simCardInputTipsMarginBottom: Resource;
  simCardPukLockedTipsMarginTop: Resource;
  simCardInputIconBackMarginRight: Resource;
  tipsTextMarginBottom: number;
  tipsTextOverflow: TextOverflow;
  tipsTextWidth: number | string;
}

export const defaultPSDLayoutConfig: PSDLayoutConfig = {
  outerScreenFlag: false,
  mixedPasswordFaceImageTipSize: $r('app.float.mixed_password_face_image_tip_size'),
  mixedPasswordFaceImageTipMargin: $r('app.float.mixed_password_face_image_tip_margin'),
  inputPwdTipWithFaceMarginTop: $r('app.float.input_tips_with_face_margin_top'),
  inputPwdTipMarginTop: $r('app.float.input_tips_margin_top'),
  inputPwdTipMinFontSize: $r('app.float.pwd_prompt_min_font_size'),
  inputPwdTipMaxFontSize: $r('app.float.pwd_prompt_fontsize'),
  numkeyboardGridItemStackSize: $r('app.float.num_keyboard_grid_item_stack_size'),
  numKeyboardGridItemBgRadius: $r('app.float.num_keyboard_bg_radius'),
  numKeyboardLetterTextHeight: $r('app.float.num_keyboard_row2_height'),
  numKeyboardBackHeight: $r('app.float.num_keyboard_back_height'),
  numKeyboardBgWidthHeight: $r('app.float.num_keyboard_bg_width_height'),
  numKeyboardSpecialKeyBgRadius: $r('app.float.num_keyboard_pecial_key_bg_radius'),
  numBoardHeight: PasswordConstants.NUM_KEYBOARD_HEIGHT,
  numBoardTopMarginPhone: PasswordConstants.NUM_KEYBOARD_TOP_MARGIN_PHONE,
  numBoardLeftMarginPhone: PasswordConstants.NUM_KEYBOARD_LEFT_MARGIN_PHONE,
  plusSignFontSize :  $r('app.float.num_keyboard_plus_sign_font_size'),
  letterTextFontSize : $r('app.float.num_keyboard_letter_font_size'),
  specialFontSize :$r('app.float.pwd_special_key_fontsize'),
  numberFontSize : $r('app.float.num_keyboard_number_font_size'),
  passwdMaskSpace: PASSWORD_MASK_SPACE,
  passwdMaskDotWidthAndHeight : $r('app.float.digitalpwd_passwdmask_dot_width_height'),
  digitalPwdMaskMarginTop: $r('app.float.digitalpwd_mask_margin_top'),
  digitalKeyBoardMarginTop: $r('app.float.digitalpwd_num_keyboard_margin_top_nomarl'),
  mixedEmergencyCallVisibility: true,
  mixedTextInputHeight: $r('app.float.pwd_input_row_height'),
  mixedTextInputMarginTop:$r('app.float.pwd_input_row_margin_top'),
  mixedPwdCombinationHeight: $r('app.float.mixed_pwd_combination_height'),
  simCardFlagVisibility : true,
  simCardInputTipsFontSize: 16,
  simCardInputTipsHeight: $r('app.float.sim_card_input_tips_height'),
  simCardPukLockedTipsFontSize: 16,
  simCardPukLockedTipsTipsHeight: $r('app.float.sim_card_puk_tips_height'),
  simCardInputTipsMarginBottom: $r('app.float.sim_card_input_tips_margin_bottom'),
  simCardPukLockedTipsMarginTop: $r('app.float.pwd_input_row_margin_top'),
  simCardInputIconBackMarginRight: $r('app.float.phone_pwd_icon_back_magin_right'),
  tipsTextMarginBottom: PasswordConstants.TIPS_TEXT_MARGIN_BOTTOM,
  tipsTextOverflow: TextOverflow.Ellipsis,
  tipsTextWidth: '100%',
}

export const outerPSDLayoutConfig: PSDLayoutConfig = {
  outerScreenFlag: true,
  mixedPasswordFaceImageTipSize : $r('app.float.outer_mixed_password_face_image_tip_size'),
  mixedPasswordFaceImageTipMargin : $r('app.float.outer_mixed_password_face_image_tip_margin'),
  inputPwdTipWithFaceMarginTop :  $r('app.float.outer_input_tips_with_face_margin_top'),
  inputPwdTipMarginTop :  $r('app.float.outer_input_tips_margin_top'),
  inputPwdTipMinFontSize : $r('app.float.outer_pwd_prompt_fontsize'),
  inputPwdTipMaxFontSize : $r('app.float.outer_pwd_prompt_fontsize'),
  numkeyboardGridItemStackSize : $r('app.float.outer_num_keyboard_grid_item_stack_size'),
  numKeyboardGridItemBgRadius : $r('app.float.outer_num_keyboard_bg_radius'),
  numKeyboardLetterTextHeight: $r('app.float.outer_num_keyboard_row2_height'),
  numKeyboardBackHeight: $r('app.float.outer_num_keyboard_back_height'),
  numKeyboardBgWidthHeight: $r('app.float.outer_num_keyboard_bg_width_height'),
  numKeyboardSpecialKeyBgRadius:$r('app.float.num_keyboard_pecial_key_bg_radius'),
  numBoardHeight: PasswordConstants.OUTER_NUM_KEYBOARD_HEIGHT,
  numBoardTopMarginPhone: PasswordConstants.OUTER_NUM_KEYBOARD_TOP_MARGIN_PHONE,
  numBoardLeftMarginPhone: PasswordConstants.OUTER_NUM_KEYBOARD_LEFT_MARGIN_PHONE,
  plusSignFontSize :  $r('app.float.outer_num_keyboard_plus_sign_font_size'),
  letterTextFontSize : $r('app.float.outer_num_keyboard_letter_font_size'),
  specialFontSize :$r('app.float.outer_pwd_special_key_fontsize'),
  numberFontSize : $r('app.float.outer_num_keyboard_number_font_size'),
  passwdMaskSpace : OUTER_PASSWORD_MASK_SPACE,
  passwdMaskDotWidthAndHeight : $r('app.float.outer_digitalpwd_passwdmask_dot_width_height'),
  digitalPwdMaskMarginTop: $r('app.float.outer_digitalpwd_mask_margin_top'),
  digitalKeyBoardMarginTop: $r('app.float.digitalpwd_num_keyboard_margin_top_outer'),
  mixedEmergencyCallVisibility : false,
  mixedTextInputHeight: $r('app.float.outer_pwd_input_row_height'),
  mixedTextInputMarginTop:$r('app.float.outer_pwd_input_row_margin_top'),
  mixedPwdCombinationHeight: $r('app.float.outer_mixed_pwd_combination_height'),
  simCardFlagVisibility : false,
  simCardInputTipsFontSize : 12,
  simCardInputTipsHeight: $r('app.float.outer_sim_card_input_tips_height'),
  simCardPukLockedTipsFontSize: 10,
  simCardPukLockedTipsTipsHeight: $r('app.float.outer_sim_card_puk_tips_height'),
  simCardInputTipsMarginBottom: $r('app.float.outer_sim_card_input_tips_margin_bottom'),
  simCardPukLockedTipsMarginTop: $r('app.float.outer_sim_card_puk_tips_margin_top'),
  simCardInputIconBackMarginRight: $r('app.float.outer_phone_pwd_icon_back_magin_right'),
  tipsTextMarginBottom: PasswordConstants.SMALL_TIPS_TEXT_MARGIN_BOTTOM,
  tipsTextOverflow: TextOverflow.MARQUEE,
  tipsTextWidth: PasswordConstants.SMALL_TIPS_TEXT_WIDTH,
}

export class PasswordLayoutConfig {
  public layoutConfig : PSDLayoutConfig = defaultPSDLayoutConfig;

  public switchToDefaultConfig(): void {
    this.layoutConfig = defaultPSDLayoutConfig;
  }
  public switchToOuterConfig(): void {
    this.layoutConfig = outerPSDLayoutConfig;
  }
}
