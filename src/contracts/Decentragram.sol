// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16;

contract Decentragram {
    string public name = "Decentragram";

    //store images
    uint256 public imageCount = 0;
    mapping(uint256 => Image) public images;

    struct Image {
        uint256 id;
        string hash;
        string description;
        uint256 tipAmount;
        address payable author;
    }

    event ImageCreated(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );



    event ImageTipped(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author  
    );

    
 
    // create images
    function uploadImage(string memory _imgHash, string memory _description)
        public
    {
        require(bytes(_description).length > 0); //valid description
        require(bytes(_imgHash).length > 0);  //valid image
        require(msg.sender != address(0x0)); // valid user

        //increase image count
        imageCount++;

        //Add images to contract
        images[imageCount] = Image(
            imageCount,
            _imgHash,
            _description,
            0,
            msg.sender
        );

        emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
    }

    // tip images
  function tipImageOwner(uint _id) public payable {
     //make sure id is valid
   require(_id>0 && _id<= imageCount); 


  //fetch image
      Image memory _image = images[_id];
      //fetch author     
      address payable _author = _image.author;
       // pay author
      _author.transfer(msg.value);
     
      _image.tipAmount = _image.tipAmount + msg.value;

      images[_id] = _image;
     
    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);


  }

}
