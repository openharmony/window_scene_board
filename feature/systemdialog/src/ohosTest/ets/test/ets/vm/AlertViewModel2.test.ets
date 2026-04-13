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
import { UIExtensionContentSession } from '@kit.AbilityKit';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { LogDomain, LogHelper } from '../../../../../main/ets/BaseCommonIndex';
import { AlertViewModel, AlertViewModelParams } from '../../../../../main/ets/vm/AlertViewModel';

export default function AlertViewModelTest() {
  describe('terminateSession_testSuite', () => {

    beforeEach(() => {
    });

    afterEach(() => {
    });

    it('should_log_success_when_terminateSelf_succeeds', 0, async () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: '',
        content: '',
        button: ''
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(0x01a00, 'SYS_UI');
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      alertviewmodel.terminateSession();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_error_when_terminateSelf_throws_exception', 0, async () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: 'testContent',
        button: 'testButton'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getLogHelper(0x01a00, 'SYS_UI');
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let originalTerminateSelf = session.terminateSelf;
      alertviewmodel.terminateSession();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });


    it('should_return_title_when_params_is_not_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = { title: 'Test Title', content: 'Test Content', button: 'Test Button' };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getDialogTitle();
      expect(result).assertEqual('Test Title');
    });

    it('should_return_empty_string_when_params_is_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: 'testContent',
        button: 'testButton'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getDialogTitle();
      expect(result).assertEqual('');
    });

    it('should_return_title_when_params_is_undefined', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: '',
        content: 'testContent',
        button: 'testButton'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getDialogTitle();
      expect(result).assertEqual('');
    });

    it('should_return_content_when_params_is_not_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: '',
        button: 'testButton'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getDialogContent();
      expect(result).assertEqual('testContent');
    });

    it('should_return_content_when_params_is_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: 'testContent',
        button: ''
      }
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getDialogContent();
      expect(result).assertUndefined();
    });


    it('should_return_button_value_when_params_is_not_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: '',
        content: 'testContent',
        button: 'testButton'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertEqual('testButton');
    });

    it('should_return_undefined_when_params_is_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: '',
        button: 'testBtn'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertUndefined();
    });

    it('should_return_empty_string_when_button_is_not_provided', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: 'testContent',
        button: ''
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertEqual('');
    });
    it('should_return_undefined_when_params_is_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: '',
        button: 'testBtn'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertUndefined();
    });

    it('should_return_empty_string_when_button_is_not_provided', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: 'testContent',
        button: ''
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertEqual('');
    });
    it('should_return_undefined_when_params_is_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: '',
        button: 'testBtn'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertUndefined();
    });

    it('should_return_empty_string_when_button_is_not_provided', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: 'testContent',
        button: ''
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertEqual('');
    });
    it('should_return_undefined_when_params_is_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: '',
        button: 'testBtn'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertUndefined();
    });

    it('should_return_empty_string_when_button_is_not_provided', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: 'testContent',
        button: ''
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertEqual('');
    });
    it('should_return_undefined_when_params_is_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: '',
        button: 'testBtn'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertUndefined();
    });

    it('should_return_empty_string_when_button_is_not_provided', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: 'testContent',
        button: ''
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertEqual('');
    });
    it('should_return_empty_string_when_button_is_not_provided', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: 'testContent',
        button: ''
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertEqual('');
    });
    it('should_return_undefined_when_params_is_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: '',
        button: 'testBtn'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertUndefined();
    });

    it('should_return_empty_string_when_button_is_not_provided', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: 'testContent',
        button: ''
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertEqual('');
    });
    it('should_return_undefined_when_params_is_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: '',
        button: 'testBtn'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertUndefined();
    });
    it('should_return_undefined_when_params_is_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: '',
        button: 'testBtn'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertUndefined();
    });

    it('should_return_empty_string_when_button_is_not_provided', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: 'testContent',
        button: ''
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertEqual('');
    });
    it('should_return_undefined_when_params_is_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: '',
        button: 'testBtn'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertUndefined();
    });

    it('should_return_empty_string_when_button_is_not_provided', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: 'testContent',
        button: ''
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertEqual('');
    });
    it('should_return_undefined_when_params_is_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: '',
        button: 'testBtn'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertUndefined();
    });

    it('should_return_empty_string_when_button_is_not_provided', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: 'testContent',
        button: ''
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertEqual('');
    });
    it('should_return_undefined_when_params_is_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: '',
        button: 'testBtn'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertUndefined();
    });

    it('should_return_empty_string_when_button_is_not_provided', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: 'testContent',
        button: ''
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertEqual('');
    });
    it('should_return_undefined_when_params_is_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: '',
        button: 'testBtn'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertUndefined();
    });

    it('should_return_empty_string_when_button_is_not_provided', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: 'testContent',
        button: ''
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertEqual('');
    });
    it('should_return_undefined_when_params_is_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: '',
        button: 'testBtn'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertUndefined();
    });

    it('should_return_empty_string_when_button_is_not_provided', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: 'testContent',
        button: ''
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertEqual('');
    });

    it('should_return_undefined_when_params_is_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: '',
        button: 'testBtn'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertUndefined();
    });

    it('should_return_empty_string_when_button_is_not_provided', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: 'testContent',
        button: ''
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertEqual('');
    });
    it('should_return_undefined_when_params_is_null', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: '',
        button: 'testBtn'
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertUndefined();
    });

    it('should_return_empty_string_when_button_is_not_provided', 0, () => {
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let params: AlertViewModelParams = {
        title: 'testTitle',
        content: 'testContent',
        button: ''
      };
      let alertviewmodel: AlertViewModel = new AlertViewModel(session, params);
      const result = alertviewmodel.getBtnValue();
      expect(result).assertEqual('');
    });
  });
}