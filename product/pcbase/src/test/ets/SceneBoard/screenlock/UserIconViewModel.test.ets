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
import { describe, it, expect } from '@ohos.test';
import UserIconViewModel, { UserIconInfo, IconImgType } from './UserIconViewModel.test';

const TAG = 'UserIconViewModelTest';

export default function UserIconViewModelTest(){
    describe('UserIconViewModel', () => {
        let viewModel: UserIconViewModel;

        beforeEach(() => {
            viewModel = UserIconViewModel.getInstance();
        });

        it('should initialize user icon data', () => {
            viewModel.initUserIconData();
            expect(viewModel.userIconInfoMap.size).toBeGreaterThan(0);
        });

        it('should get current user icon info', () => {
            const userId = 1;
            const userIconInfo = viewModel.getCurrentUserIconInfo(userId);
            expect(userIconInfo).toBeInstanceOf(UserIconInfo);
            expect(userIconInfo.userId).toBe(userId);
        });

        it('should register and unregister user icon updated callback', () => {
            const userId = 1;
            const callback = jest.fn();
            viewModel.registerUserIconUpdatedCallback(userId, callback);
            viewModel.runUserIconUpdatedCallback(userId);
            expect(callback).toHaveBeenCalled();
            viewModel.unregisterUserIconUpdatedCallback(userId);
            viewModel.runUserIconUpdatedCallback(userId);
            expect(callback).toHaveBeenCalledTimes(1);
        });

        it('should use default icon data when photo is empty', () => {
            const userId = 1;
            viewModel.updateUserIconData(userId, '');
            const userIconInfo = viewModel.getCurrentUserIconInfo(userId);
            expect(userIconInfo.iconType).toBe(IconImgType.STATIC);
        });

        it('should create clip image when icon type is clip', () => {
            const userId = 1;
            const photoStr = '{"type": "0", "defaultImg": "path/to/image"}';
            viewModel.updateUserIconData(userId, photoStr);
            const userIconInfo = viewModel.getCurrentUserIconInfo(userId);
            expect(userIconInfo.iconType).toBe(IconImgType.CLIP);
        });

        // Add more test cases to cover different branches and scenarios
    });
}
