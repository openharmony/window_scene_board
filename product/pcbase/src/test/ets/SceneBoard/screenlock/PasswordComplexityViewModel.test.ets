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
import { PasswordComplexityViewModel } from './PasswordComplexityViewModel.test';
import { osAccount } from '@ohos.account.osAccount';

const TAG = 'PasswordComplexityViewModelTest';

export default function PasswordComplexityViewModelTest(){
    describe('PasswordComplexityViewModel', () => {
        let viewModel: PasswordComplexityViewModel;

        beforeEach(() => {
            viewModel = new PasswordComplexityViewModel();
        });

        it('should validate old password correctly', async () => {
            viewModel.oldPasswordInput = 'correctPassword';
            viewModel.isOldPasswordChanged = true;

            const mockAuthUser = jest.spyOn(service, 'authUser').mockImplementation((_, password, callback) => {
                callback(0, { remainTimes: 5, freezingTime: 0, token: new Uint8Array([]) });
            });

            await viewModel.checkOldPasswordInput();
            expect(viewModel.isAuthPinSuccess).toBe(true);
            expect(mockAuthUser).toHaveBeenCalledWith(expect.any(), 'correctPassword', expect.any());
        });

        it('should validate new password length', () => {
            viewModel.newPasswordInput = 'short';
            viewModel.checkNewPasswordInput();
            expect(viewModel.isNewPasswordWarningShow).toBe(true);
        });

        it('should validate confirm password matches new password', () => {
            viewModel.newPasswordInput = 'newPassword123';
            viewModel.confirmPasswordInput = 'newPassword123';
            viewModel.checkConfirmPasswordInput();
            expect(viewModel.isConfirmPasswordWarningShow).toBe(false);
        });

        it('should update password successfully', async () => {
            viewModel.oldPasswordInput = 'oldPassword';
            viewModel.newPasswordInput = 'newPassword123';

            const mockUpdateCredential = jest.spyOn(viewModel, 'updateCredential').mockImplementation((_, success, _) => {
                success();
            });

            await viewModel.updatePin(() => {}, () => {});
            expect(viewModel.isUpdatePinSuccess).toBe(true);
            expect(mockUpdateCredential).toHaveBeenCalled();
        });

        it('should check password complexity', () => {
            viewModel.newPasswordInput = 'short';
            viewModel.minLength = 6;
            viewModel.maxLength = 32;
            viewModel.checkPasswordComplexity();
            expect(viewModel.isNewPasswordWarningShow).toBe(true);
        });
    });
}

