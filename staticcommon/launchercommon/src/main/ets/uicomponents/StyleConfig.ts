/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { DeviceHelper} from '@ohos/frameworkwrapper';
import { DeviceState } from '../constants/CommonConstants';
import { StyleConstants } from '../constants/StyleConstants';

const PC_BUTTON_WIDTH: number = 176;
const PC_DIALOG_WIDTH: number = 400;
const PC_DIALOG_HEIGHT: number = 560;
const PAD_BUTTON_WIDTH: number = 182;
const PAD_DIALOG_WIDTH: number = 480;
const PADDING_SMALL: number = 24;
const PADDING_BIG: number = 32;

export class StyleConfig {
  public static style(): Style {
    if (AppStorage.get<number>('folderStatus') === DeviceState.EXPAND_STATE) {
      return PHONE_FOLDER_STYLE;
    }
    if (DeviceHelper.isPhone()) {
      return PHONE_STYLE;
    } else if (DeviceHelper.isPad()) {
      return PAD_STYLE;
    } else {
      return PC_STYLE;
    }
  }

  static buttonStyle(): ButtonStyle {
    return StyleConfig.style().buttonStyle;
  }

  static rootContainerStyle(): RootContainerStyle {
    return StyleConfig.style().rootContainerStyle;
  }

  static showDivider(): boolean {
    return StyleConfig.style().showButtonDivider;
  }
}

interface RootContainerStyle {
  paddingBottom: number;
  width: number | string;
  height?: number | string;
  padding: number;
}

interface ButtonStyle {
  width: number;
  height: number;
  backgroundColor: ResourceColor;
}

interface Style {
  rootContainerStyle: RootContainerStyle;
  buttonStyle: ButtonStyle;
  showButtonDivider: boolean;
}

const PHONE_STYLE: Style = {
  rootContainerStyle: {
    width: '',
    paddingBottom: StyleConstants.DEFAULT_DIALOG_BOTTOM_MARGIN,
    padding: PADDING_SMALL
  },
  buttonStyle: {
    width: StyleConstants.DEFAULT_BUTTON_WIDTH,
    height: StyleConstants.DEFAULT_BUTTON_HEIGHT,
    backgroundColor: StyleConstants.DEFAULT_BG_COLOR
  },
  showButtonDivider: true
};

const PC_STYLE: Style = {
  rootContainerStyle: {
    width: PC_DIALOG_WIDTH,
    paddingBottom: StyleConstants.DEFAULT_24,
    height: PC_DIALOG_HEIGHT,
    padding: PADDING_BIG
  },
  buttonStyle: {
    width: PC_BUTTON_WIDTH,
    height: StyleConstants.DEFAULT_BUTTON_HEIGHT,
    backgroundColor: StyleConstants.DEFAULT_BUTTON_COLOR_FORM_DIALOG
  },
  showButtonDivider: false
};

const PAD_STYLE: Style = {
  rootContainerStyle: {
    width: PAD_DIALOG_WIDTH,
    paddingBottom: StyleConstants.DEFAULT_16,
    height: PC_DIALOG_HEIGHT,
    padding: PADDING_BIG
  },
  buttonStyle: {
    width: PAD_BUTTON_WIDTH,
    height: StyleConstants.DEFAULT_BUTTON_HEIGHT,
    backgroundColor: StyleConstants.DEFAULT_BG_COLOR
  },
  showButtonDivider: true
};

const PHONE_FOLDER_STYLE: Style = {
  rootContainerStyle: {
    width: PAD_DIALOG_WIDTH,
    paddingBottom: StyleConstants.DEFAULT_DIALOG_BOTTOM_MARGIN,
    padding: PADDING_BIG,
    height: PC_DIALOG_HEIGHT
  },
  buttonStyle: PHONE_STYLE.buttonStyle,
  showButtonDivider: true
};