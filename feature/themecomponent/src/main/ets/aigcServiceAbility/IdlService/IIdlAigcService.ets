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
import IIdlAigcExtServiceCallback from './callback/IIdlAigcExtServiceCallback';

export default interface IIdlAigcService {
    /**
     * 获取AIGC图片
     *
     * @param themeId
     * @param url
     * @param uid
     * @param token
     * @param algParam aigc算法参数
     * @param callback 动作执行的结果
     */
    requestImage(themeId: string, url: string, uid: string, token: string, algParam: string,
        callback: resultStringCallback): void;

    /**
     * 服务端检查算法执行状态接口 0:处理完，1：正在处理，2：任务已取消
     *
     * @param themeId
     * @param callback 动作执行的结果
     */
    checkState(themeId: string, callback: resultStringCallback): void;

    /**
     * 删除路径下的文件/夹
     *
     * @param toRemovePaths 路径列表
     * @param apply 是否要应用
     * @param themeId
     * @param isEnableNotify 是否通知主题切换
     * @param callback 动作执行的结果
     */
    removePathList(toRemovePaths: string[], apply: boolean, themeId: string, isEnableNotify: boolean,
        callback: operateResult): void;

    /**
     * 向服务端注册回调接口，用于服务端主动向客户端通信
     *
     * @param key 区分接口的键
     * @param cb 回调接口
     * @param callback 注册动作执行的结果
     */
    register(key: string, cb: IIdlAigcExtServiceCallback, callback: operateResult): void;

    /**
     * 向服务端注销回调接口
     *
     * @param key 区分接口的键
     * @param callback 注销动作执行的结果
     */
    unRegister(key: string, callback: operateResult): void;

    /**
     * 同步查询状态
     *
     * @param themeId
     * @param callback
     */
    checkStateSync(themeId: string, callback: checkStateCallback): void;

    /**
     * 调用scb通知接口
     *
     * @param themeId
     * @param notifyType 通知类型 0-开始 -1-失败 10000-删除themeId的通知
     * @param errCode 端侧错误码
     */
    dealWithPandoraNotify(themeId: string, notifyType: number, errCode: number, callback: operateResult,
        version: string): void;

    /**
     * 设置折叠屏壁纸 折叠态、展开态的裁切区域
     *
     * @param themeId themeId
     * @param foldedClipAreas 出图的大小、折叠态、展开态的裁切区域
     * @param callback 端侧回调
     */
    setFoldedClipAreas(themeId: string, foldedClipAreas: string, callback: operateResult): void;

    /**
     * activateAndBeginPandora
     *
     * @param paramList 结构为[预制包路径, 沙箱路径, 配置文件夹相对路径, uid, token, algParam]
     * @param callback 端侧回调
     */
    activateAndBeginPandora(paramList: string[], version: string, callback: operateResult): void;

    /**
     * 生成图片
     * @param themeId 主题ID
     * @param url config文件路径
     * @param callback 回调函数
     */
    generatePictures(themeId: string, url: string, callback: resultStringCallback): void;

    /**
     * 移除AIGC2主题
     * @param toRemovePaths 路径列表
     * @param apply 是否要应用
     * @param themeId
     * @param isEnableNotify 是否通知主题切换
     * @param callback 动作执行的结果
     */
    removeAIGC2PathList(toRemovePaths: string[], apply: boolean, themeId: string, isEnableNotify: boolean,
        callback: operateResult): void;

    /**
     * 首先用原图激活主题，并上传原图到云侧做AIGC生成
     *
     * @param paramList 结构为[预制包路径, 创建该任务的时间戳, 上云参数]
     * @param callback 端侧回调
     */
    activateAndGenerateImages(paramList: string[], callback: operateResult): void;

    /**
     * 上云生成
     *
     * @param themeID 主题ID
     * @param url 上传图片地址
     * @param algParam 算法所需参数
     * @param callback 端侧回调
     */
    generateImages(themeID: string, url: string, algParam: string, callback: resultStringCallback): void;

    /**
     * 开始生成
     *
     * @param paramList 结构为[预制包路径, 沙箱路径, 配置文件夹相对路径, uid, token, algParam]
     * @param callback 端侧回调
     */
    startGeneratePandora(paramList: string[], callback: resultStringCallback): void;
}

export type resultStringCallback = (errCode: number, returnValue: string) => void;
export type operateResult = (errCode: number) => void;
export type checkStateCallback = (result: number, statusCode: number, errCode: number) => void;
