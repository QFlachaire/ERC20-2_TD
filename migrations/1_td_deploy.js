var TDErc20 = artifacts.require("ERC20TD.sol");
var ERC20Claimable = artifacts.require("ERC20Claimable.sol");
var evaluator = artifacts.require("Evaluator.sol");


module.exports = (deployer, network, accounts) => {
    deployer.then(async () => {
        // await deployTDToken(deployer, network, accounts); 
        // await deployEvaluator(deployer, network, accounts); 
        // await setPermissionsAndRandomValues(deployer, network, accounts); 
        // await deployRecap(deployer, network, accounts); 

		await hardcodeContractAddress(deployer, network, accounts)
		await testDeployment(deployer, network, accounts);
    });
};

async function deployTDToken(deployer, network, accounts) {
	TDToken = await TDErc20.new("TD-ERC20-101","TD-ERC20-101",web3.utils.toBN("20000000000000000000000000000"))
	ClaimableToken = await ERC20Claimable.new("ClaimableToken","CLTK",web3.utils.toBN("20000000000000000000000000000"))
}

async function deployEvaluator(deployer, network, accounts) {
	Evaluator = await evaluator.new(TDToken.address, ClaimableToken.address)
}


async function setPermissionsAndRandomValues(deployer, network, accounts) {
	await TDToken.setTeacher(Evaluator.address, true)
}

async function deployRecap(deployer, network, accounts) {
	console.log("TDToken " + TDToken.address)
	console.log("ClaimableToken " + ClaimableToken.address)
	console.log("Evaluator " + Evaluator.address)
}

async function hardcodeContractAddress(deployer, network, accounts) {
	TDToken = await TDErc20.at("0x77dAe18835b08A75490619DF90a3Fa5f4120bB2E")
	ClaimableToken = await ERC20Claimable.at("0xb5d82FEE98d62cb7Bc76eabAd5879fa4b29fFE94")
	Evaluator = await evaluator.at("0x384C00Ff43Ed5376F2d7ee814677a15f3e330705")

}

async function testDeployment(depioyer, network, accounts) { 
	i = 0;

	getBalance = await TDToken.balanceOf(accounts[i]);
	console.log("Init Balance " + getBalance.toString());

	// Ex1
	await ERC20Claimable.claimTokens({from: accounts[i]});
	await Evaluator.ex1_claimedPoints({from: accounts[i]});
	getBalance = await TDToken.balanceOf(accounts[i]);
	console.log("Ex1 Balance " + getBalance.toString());

}